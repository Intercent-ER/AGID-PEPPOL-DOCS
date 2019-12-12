/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.javest.servlet.filter;

import com.javest.util.ObjectPool;
import java.io.File;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
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

    private ObjectPool<Asciidoctor> adocPool;
    private ServletContext context;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        context = filterConfig.getServletContext();

        adocPool = new ObjectPool<Asciidoctor>(1, 10, 5) {
            @Override
            protected Asciidoctor createObject() {
                // create an Asciidoctor object which takes some time for creation
                return Asciidoctor.Factory.create();
            }
        };
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        final HttpServletRequest req = (HttpServletRequest) request;
        final Asciidoctor asciidoctor = adocPool.borrowObject();
        final String webAppPath = context.getRealPath("/");

        try {

            AttributesBuilder attributes = AttributesBuilder.attributes();
            attributes.setAnchors(true);
            attributes.linkCss(true);
            attributes.stylesDir("/css");
            attributes.styleSheetName("asciidoctor-default.css");
            //attributes.attribute("pdf-stylesdir", "/ABSOLUTE-PATH or RELATIVE-PATH")
            //attributes.attribute("pdf-style", "base")

            OptionsBuilder options = OptionsBuilder.options().toFile(false).headerFooter(true).safe(SafeMode.UNSAFE);
            options.attributes(attributes.get());

            String html = asciidoctor.convertFile(
                    new File(webAppPath, req.getRequestURI()), options);
            
            /*
        val options = options()
                .backend("pdf")
                .toStream(baos)
                .safe(SafeMode.UNSAFE)
                .attributes(attributes).get()

        asciidoctor.convert(inStr, options)
              */  
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(html);
            response.setContentLength(html.length());
        } catch (Exception ex) {
            throw ex;
        } finally {
            adocPool.returnObject(asciidoctor);
        }

        // pass the request along the filter chain
        //chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        adocPool.shutdown();
    }

}
