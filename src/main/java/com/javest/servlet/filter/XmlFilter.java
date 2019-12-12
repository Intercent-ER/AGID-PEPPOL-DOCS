/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.javest.servlet.filter;

import com.javest.util.IOUtils;
import com.javest.util.ObjectPool;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.logging.Logger;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 *
 * @author JST-HQ
 * @version 1.0
 */
public class XmlFilter implements Filter {
    private static final Logger LOGGER = Logger.getLogger(XmlFilter.class.getName());
    private static final TransformerFactory XSLT_FACTORY = getTransformerFactory("net.sf.saxon.TransformerFactoryImpl");
    
    private static TransformerFactory getTransformerFactory(String factoryImpl) {
        try {
            return (TransformerFactory) Class.forName(factoryImpl).newInstance();
        } catch (Exception ex) {
            LOGGER.severe(ex.toString());
        }

        return null;
    }
    
    private ObjectPool<Transformer> transPool;
    private ServletContext context;
    private String webAppPath;
    private Templates adapter;
    private String suffix = null;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        context = filterConfig.getServletContext();
        webAppPath = context.getRealPath("/");
        
        suffix = filterConfig.getInitParameter("suffix");
        
        if (suffix == null)
            suffix = "xml";

        final Source xslSource = new StreamSource(new File(webAppPath, filterConfig.getInitParameter("adapter")));
        
        try {
            adapter = XSLT_FACTORY.newTemplates(xslSource);
        } catch (TransformerConfigurationException ex) {
            LOGGER.severe(ex.getMessage());
        }

        transPool = new ObjectPool<Transformer>(1, 10, 5) {
            @Override
            protected Transformer createObject() {
                Transformer transformer = null;
                
                try {
                    // create a Transformer object which takes some time for creation
                    transformer = adapter.newTransformer();

                    //transformer.setErrorListener(errorHandler);
                    //setCatalogResolver(transformer, catalogResolver);
                } catch (TransformerConfigurationException ex) {
                    LOGGER.severe(ex.getMessage());
                }
                
                return transformer;
            }
        };
       
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        final HttpServletRequest req = (HttpServletRequest) request;
        final Transformer transformer = transPool.borrowObject();

        OutputStream os;
        Source source = null;
        Result result = null;
        String requestUri = req.getRequestURI();
        
        if (!requestUri.endsWith("." + suffix)) {
            // pass the request along the filter chain
            chain.doFilter(request, response);
            return;
        }
        
        try {
            response.setContentType("text/html;charset=UTF-8");
            os = response.getOutputStream(); //.getWriter().write(html);

            source = new StreamSource(new File(webAppPath, requestUri));
            result = new StreamResult(os instanceof BufferedOutputStream ? os : new BufferedOutputStream(os));
            transformer.setOutputProperty(OutputKeys.INDENT, "no");
            transformer.transform(source, result);
            //response.setContentLength(html.length());
        } catch (Exception ex) {
            throw new ServletException(ex);
        } finally {
            transPool.returnObject(transformer);
            
            IOUtils.close(source);
            IOUtils.close(result);
        }

    }
    

    @Override
    public void destroy() {
        transPool.shutdown();
    }
    
}
