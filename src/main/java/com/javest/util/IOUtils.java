/*
 * IOUtils.java
 *
 * Created on 3 gennaio 2007, 20.45
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.javest.util;

import java.io.*;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.xml.sax.InputSource;

/**
 * @version 1.3.2 (extract)
 * @author Roberto Cisternino
 */
public class IOUtils {

    private IOUtils() {
    }

    private static void close(Closeable c) {
        try {
            c.close();
        } catch (IOException ex) {
            // Ignore
        }
    }

    public static final void close(InputStream is) {
        if (is != null) {
            close((Closeable) is);
        }
    }

    public static final void close(Reader r) {
        if (r != null) {
            close((Closeable) r);
        }
    }

    public static final void close(RandomAccessFile f) {
        if (f != null) {
            close((Closeable) f);
        }
    }

    public static final void closeAndSync(FileOutputStream fos) {
        if (fos != null) {
            try {
                fos.flush();
                fos.getFD().sync();
            } catch (IOException ex) {
                // Ignore
            }

            close((Closeable) fos);
        }
    }

    public static final void close(OutputStream os) {
        if (os != null) {
            try {
                os.flush();
            } catch (IOException ex) {
                // Ignore
            }

            close((Closeable) os);
        }
    }

    public static final void close(Writer w) {
        if (w != null) {
            try {
                w.flush();
            } catch (IOException ex) {
                // Ignore
            }

            close((Closeable) w);
        }
    }

    public static final void close(Source src) {
        if (src instanceof SAXSource) {
            InputSource is = ((SAXSource) src).getInputSource();

            if (is != null) {
                IOUtils.close(is.getByteStream());
                IOUtils.close(is.getCharacterStream());
            }
        } else if (src instanceof StreamSource) {
            StreamSource ss = (StreamSource) src;
            
            IOUtils.close(ss.getInputStream());
            IOUtils.close(ss.getReader());
        }
    }

    public static final void close(Result res) {
        if (res instanceof StreamResult) {
            StreamResult sr = (StreamResult) res;

            IOUtils.close(sr.getOutputStream());
            IOUtils.close(sr.getWriter());
        }
    }
    
}
