/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.javest.servlet.filter;

import com.javest.util.IOUtils;
import com.javest.util.ObjectPool;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringReader;
import java.net.URI;
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
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.FopFactoryBuilder;
import org.apache.xmlgraphics.util.MimeConstants;
import org.asciidoctor.Asciidoctor;
import org.asciidoctor.AttributesBuilder;
import org.asciidoctor.OptionsBuilder;
import org.asciidoctor.SafeMode;

/**
 *
 * @author JST-HQ
 * @version 1.0
 */
public class AsciidocFilter implements Filter {
    private static final Logger LOGGER = Logger.getLogger(AsciidocFilter.class.getName());
    private static final String XSLTC_TRANSFORMER = "com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl";

    private ObjectPool<Asciidoctor> adocPool;
    private ObjectPool<Transformer> transPool;
    private static final TransformerFactory XSLT_FACTORY = TransformerFactory.newInstance();    // XSLT 1.0
    private ServletContext context;
    private String webAppPath;
    // DocBook XSL-FO adapter
    private Templates adapter;
//    FopFactoryBuilder builder;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        //System.setProperty("javax.xml.transform.TransformerFactory", XSLTC_TRANSFORMER);
        
        // Performance tuning
        //System.setProperty("jruby.compat.version", "RUBY1_9");
        //System.setProperty("jruby.compile.mode", "OFF");
        
        context = filterConfig.getServletContext();
        webAppPath = context.getRealPath("/");

        adocPool = new ObjectPool<Asciidoctor>(1, 10, 5) {
            @Override
            protected Asciidoctor createObject() {
                // create an Asciidoctor object which takes some time for creation
                return Asciidoctor.Factory.create();
            }
        };
        
        final Source xslSource = new StreamSource(new File(webAppPath, filterConfig.getInitParameter("docbook-xsl-fo-adapter")));
        
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

//        builder = new FopFactoryBuilder(new File(webAppPath).toURI());
//        builder.setSourceResolution(120);   // 120 dpi
//        builder.setTargetResolution(120);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        final HttpServletRequest req = (HttpServletRequest) request;
        final Asciidoctor asciidoctor = adocPool.borrowObject();
        final String servletPath = req.getServletPath();
        final File asciidocFile = new File(webAppPath, servletPath);
        final URI baseUri = asciidocFile.getParentFile().toURI();
        Transformer transformer = null;
        StreamSource source = null;
        Result result = null;

        try {
            AttributesBuilder attributes = AttributesBuilder.attributes();
            OptionsBuilder options = OptionsBuilder.options();
            
            if ("pdf".equals(req.getParameter("format"))) {
                transformer = transPool.borrowObject();

                // AsciiDoc to DocBook
                options.backend("docbook").headerFooter(true).safe(SafeMode.UNSAFE).toFile(true).inPlace(true);
                asciidoctor.convertFile(asciidocFile, options);

                //options.attributes(attributes.get());
       
                // DocBook to XSL-FO
                //os = response.getOutputStream(); //.getWriter().write(html);

                source = new StreamSource(new File(webAppPath, servletPath.substring(0, servletPath.lastIndexOf(".")) + ".xml"));
                //result = new StreamResult(os instanceof BufferedOutputStream ? os : new BufferedOutputStream(os));
            
                // XSL-FO to PDF
                FopFactory fopFactory = FopFactory.newInstance(baseUri);
                // builder.setBaseURI(baseUri);
                // FopFactory fopFactory = builder.build();
                
                //Setup a buffer to obtain the content length
                ByteArrayOutputStream out = new ByteArrayOutputStream();

                //Setup FOP
                Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, out);

                //Make sure the XSL transformation's result is piped through to FOP
                result = new SAXResult(fop.getDefaultHandler());

                //Start the transformation and rendering process
                //transformer.setParameter("generate.index", "1");  // Do not generate an index
                //transformer.setParameter("generate.toc", "0");  // Do not generate an index
                //transformer.setParameter("process.source.toc", 1);
                //transformer.setParameter("process.empty.source.toc", 1);
/*                transformer.setParameter("generate.toc", "'appendix  toc,title\n" +
"article/appendix  nop\n" +
"article   toc,title\n" +
"book      toc,title,figure,table,example,equation\n" +
"chapter   toc,title\n" +
"part      toc,title\n" +
"preface   toc,title\n" +
"qandadiv  toc\n" +
"qandaset  toc\n" +
"reference toc,title\n" +
"sect1     toc\n" +
"sect2     toc\n" +
"sect3     toc\n" +
"sect4     toc\n" +
"sect5     toc\n" +
"section   toc\n" +
"set       toc,title'");  // TOC
*/
                transformer.setParameter("ulink.show", 0);  // Do not display URLs after ulinks
                transformer.setOutputProperty(OutputKeys.INDENT, "no");
                transformer.transform(source, result);
                //response.setContentLength(html.length());
                
                //Prepare response
                response.setContentType("application/pdf");
                response.setContentLength(out.size());

                //Send content to Browser
                response.getOutputStream().write(out.toByteArray());
                response.getOutputStream().flush();
                /*
                try (OutputStream outputStream = new FileOutputStream(new File(webAppPath, servletPath.substring(0, servletPath.lastIndexOf(".")) + ".pdf"))) {
                    out.writeTo(outputStream);
                    out.flush();
                    request.getRequestDispatcher("/pdfjs/web/viewer.html?file="+ servletPath.substring(0, servletPath.lastIndexOf(".")) + ".pdf").forward(request, response);
                }*/
            } else {    // HTML5
                attributes.setAnchors(true);
                attributes.linkCss(true);
                attributes.stylesDir(req.getContextPath() + "/css");
                attributes.styleSheetName("asciidoctor-default.css");
                
                options.toFile(false).headerFooter(true).safe(SafeMode.UNSAFE).attributes(attributes.get());

                String html = asciidoctor.convertFile(asciidocFile, options);

                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write(html);
                response.setContentLength(html.length());
            }

        } catch (Exception ex) {
            throw new ServletException(ex);
        } finally {
            adocPool.returnObject(asciidoctor);
            
            if (transformer != null)
                transPool.returnObject(transformer);

            IOUtils.close(source);
            IOUtils.close(result);
        }

        // pass the request along the filter chain
        //chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        adocPool.shutdown();
        transPool.shutdown();
    }

}
