package com.javest.net;

/**
 * A class to handle HTTP downloads of web published sources and protected file systems. 
 *
 * @author Roberto Cisternino
 * @version 1.1
 */
import com.javest.util.IOUtils;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.PageContext;

public class HTTPResourceDownload {
    protected HttpServletRequest request;
    protected HttpServletResponse response;
    protected ServletContext application;
    private boolean denyPhysicalPath;
    private String contentDisposition;
    private String contentPresentation = "attachment";	// inline / attachment
    private boolean contentLengthIsRequired = true;
    private boolean debug = false;
    private boolean disableCache = false;
    
    public HTTPResourceDownload() {
        denyPhysicalPath = false;
        contentDisposition = "";
    }

    public final void initialize(PageContext pageContext)
            throws ServletException {
        application = pageContext.getServletContext();
        request = (HttpServletRequest) pageContext.getRequest();
        response = (HttpServletResponse) pageContext.getResponse();
    }
    
    public final void initialize(HttpServletRequest req, HttpServletResponse res) {
        application = req.getServletContext();
        request = req;
        response = res;
    }
    
    public void downloadFile(Download source)
            throws IOException, ServletException {
        downloadFile(source.getFileIn(), source.getContentType(), source.getFileOut());
    }

    public void downloadFile(String sourceFilePathName)
            throws IOException, ServletException {
        downloadFile(sourceFilePathName, null, null);
    }

    public void downloadFile(String sourceFilePathName, String contentType)
            throws IOException, ServletException {
        downloadFile(sourceFilePathName, contentType, null);
    }

    public void downloadFile(String sourceFilePathName, String contentType, String destFileName)
            throws IOException, ServletException {
        downloadFile(sourceFilePathName, contentType, destFileName, 1024 * 512);	// 512 Kb
    }

    /**
     * v 2.0
     * @param sourceFilePathName
     * @param contentType
     * @param destFileName
     * @param blockSize
     * @throws IOException
     * @throws ServletException
     */
    public void downloadFile(String sourceFilePathName, String contentType, String destFileName, int blockSize)
            throws IOException, ServletException {
        if (sourceFilePathName == null || sourceFilePathName.equals("")) {
            throw new IllegalArgumentException(String.valueOf((new StringBuilder("File '")).append(sourceFilePathName).append("' not found.")));
        }

        if (!isVirtual(sourceFilePathName) && denyPhysicalPath) {
            throw new SecurityException("Physical path is denied.");
        }

        if (isVirtual(sourceFilePathName)) {
            sourceFilePathName = application.getRealPath(sourceFilePathName);
        }

        File file = new File(sourceFilePathName);
        InputStream is = new BufferedInputStream(new FileInputStream(file));
        long contentLength = file.length();

        downloadFile(is, sourceFilePathName, contentLength, contentType, destFileName, blockSize);
    }

    public void downloadFile(File sourceFile, String contentType, String destFileName, int blockSize)
            throws IOException, ServletException {
        InputStream is = new BufferedInputStream(new FileInputStream(sourceFile));
        long contentLength = sourceFile.length();

        downloadFile(is, sourceFile.getPath(), contentLength, contentType, destFileName, blockSize);
    }

    /**
     * v 2.1
     * @param is
     * @param sourceFileName
     * @param contentLength
     * @param contentType
     * @param targetFileName
     * @param blockSize
     * @throws IOException
     * @throws ServletException
     */
    public void downloadFile(InputStream is, String sourceFileName, long contentLength, String contentType, String targetFileName, int blockSize)
            throws IOException, ServletException {
        int readBytes = 0;
        int totalRead = 0;

        if (blockSize <= 0) {
            blockSize = 8 * 1024;
        }

        byte b[] = new byte[blockSize];
        final StringBuilder debugResponse = new StringBuilder("DEBUG:\r\n");
        // String contentEncoding = null;

        OutputStream outStream = null;

        // Set Content Type
//		if (isZipped(sourceFilePathName)) {
//			contentType = "application/x-zip-compressed";
//			contentType = "application/zip";	// Other way
//		} else 
        if (contentType == null || contentType.length() == 0) {
            if (request.getHeader("user-agent") == null || request.getHeader("user-agent").toUpperCase().contains("IE")) {
                contentType = "application/x-force-download";
            } else // Standard W3C Content Type to force download (Netscape, Opera, Mozilla, Firefox)
            {
                contentType = "application/octet-stream";
            }
        }

        response.setContentType(contentType);
        
        if (debug)
            debugResponse.append("Content-Type: ").append(contentType).append("\r\n");

        if (contentLengthIsRequired) {
            // Adjusts the content-encoding depending of the Client request
            String encoding = request.getHeader("Accept-Encoding");
            
            if (debug)
                debugResponse.append("Request Accept-Encoding: ").append(encoding).append("\r\n");
            /*
            if (isZipped(sourceFilePathName)) {
            if (encoding != null && encoding.indexOf("gzip") != -1) {
            m_response.setHeader("Content-Encoding", "gzip");
            debugResponse.append("Content-Encoding: gzip\r\n");
            }
            else if(encoding != null && encoding.indexOf("compress") != -1) {
            m_response.setHeader("Content-Encoding", "compress");
            debugResponse.append("Content-Encoding: compress\r\n");
            }
            else {
            m_response.setContentLength((int)fileLen);
            debugResponse.append("Content-Length: " + String.valueOf(fileLen)+ "\r\n");
            }
            } else {
             */
            response.setContentLength((int) contentLength);
            
            if (debug)
                debugResponse.append("Content-Length: ").append(String.valueOf(contentLength)).append("\r\n");
//			}
        }

        // Set Content Disposition
        contentDisposition = contentDisposition != null && !contentDisposition.equals("") ? contentDisposition : contentPresentation + ";";

        if (targetFileName == null) {
            contentDisposition = String.valueOf((new StringBuilder(String.valueOf(contentDisposition))).append(" filename=").append(getFileName(sourceFileName)));
        } else if (targetFileName.length() > 0) {
            contentDisposition = String.valueOf((new StringBuilder(String.valueOf(contentDisposition))).append(" filename=").append(targetFileName));
        }
        response.setHeader("Content-Disposition", contentDisposition);
        
        if (debug)
            debugResponse.append("Content-Disposition: ").append(contentDisposition).append("\r\n");

        // Disables browser cache
        if (disableCache) {
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            response.setHeader("Cache-Control", "post-check=0, pre-check=0");
            response.setHeader("Expires", "0");
            response.setHeader("Pragma", "No-Cache");

            if (debug) {
                debugResponse.append("Cache-Control: no-store, no-cache, must-revalidate\r\n")
                        .append("Cache-Control: post-check=0, pre-check=0\r\n")
                        .append("Expires: 0\r\n")
                        .append("Pragma: No-Cache\r\n");
            }
        }

        if (debug) {
            System.out.println(debugResponse.toString());
        }

        // Obtains the OutputStream
        if (!response.isCommitted()) {
            outStream = new BufferedOutputStream(response.getOutputStream());
            
            try {
                
                while (is.available() > 0) {
                    readBytes = is.read(b, 0, blockSize);

                    if (readBytes == -1) {
                        break;
                    }

                    totalRead += readBytes;
                    outStream.write(b, 0, readBytes);

                    Thread.yield();
                }
            } catch (IOException ioex) {
                throw ioex;
            } finally {
                outStream.flush();
                IOUtils.close(is);
            }
        }
    }

    private String getFileName(String filePathName) {
        int pos = filePathName.lastIndexOf('/');

        if (pos != -1) {
            return filePathName.substring(pos + 1, filePathName.length());
        }

        pos = filePathName.lastIndexOf('\\');

        if (pos != -1) {
            return filePathName.substring(pos + 1, filePathName.length());
        } else {
            return filePathName;
        }
    }

    public void setDenyPhysicalPath(boolean deny) {
        denyPhysicalPath = deny;
    }

    public void setContentDisposition(String contentDisposition) {
        this.contentDisposition = contentDisposition;
    }

    private boolean isVirtual(String pathName) {
        if (application.getRealPath(pathName) != null) {
            File virtualFile = new File(application.getRealPath(pathName));
            return virtualFile.exists();
        } else {
            return false;
        }
    }

    public static final boolean isZipped(String fileName) {
        fileName = fileName.toLowerCase().trim();

        return (fileName.endsWith(".zip") || fileName.endsWith(".gz")
                || fileName.endsWith(".gzip") || fileName.endsWith(".z")
                || fileName.endsWith(".tgz"));
    }

    public final void setContentPresentation(String presentationType) {
        contentPresentation = presentationType.trim().toLowerCase();
    }

    public final void setEnableContentLength(boolean enabled) {
        contentLengthIsRequired = enabled;
    }

    public final void setDebug(boolean enabled) {
        debug = enabled;
    }

    public final void setDisableCache(boolean enabled) {
        disableCache = enabled;
    }
    
}
