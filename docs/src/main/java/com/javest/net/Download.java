package com.javest.net;

/**
 * @author Roberto Cisternino
 *
 * Persistence of files to be downloaded
 */
public class Download implements java.io.Serializable {
    public static final String FORCE_DOWNLOAD_CONTENT_TYPE = "application/x-force-download";
    
    private String fileIn;
    private String fileOut;
    private long fileDate;
    private String contentType;

    public Download(String fileIn, String fileOut) {
        this(fileIn, fileOut, FORCE_DOWNLOAD_CONTENT_TYPE);
    }

    public Download(String fileIn, String fileOut, long fileDate) {
        this(fileIn, fileOut, fileDate, FORCE_DOWNLOAD_CONTENT_TYPE);
    }

    public Download(String fileIn, String fileOut, long fileDate,
            String contentType) {
        this.fileIn = fileIn;
        this.fileOut = fileOut;
        this.fileDate = fileDate;
        this.contentType = contentType;
    }

    public Download(String fileIn, String fileOut, String contentType) {
        this.fileIn = fileIn;
        this.fileOut = fileOut;
        this.contentType = contentType;
    }

    /**
     * Returns the contentType.
     *
     * @return String
     */
    public String getContentType() {
        return contentType;
    }

    /**
     * Returns the fileIn.
     *
     * @return String
     */
    public String getFileIn() {
        return fileIn;
    }

    /**
     * Returns the fileOut.
     *
     * @return String
     */
    public String getFileOut() {
        return fileOut;
    }

    /**
     * Sets the contentType.
     *
     * @param contentType
     *                    The contentType to set
     */
    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    /**
     * Sets the fileIn.
     *
     * @param fileIn
     *               The fileIn to set
     */
    public void setFileIn(String fileIn) {
        this.fileIn = fileIn;
    }

    /**
     * Sets the fileOut.
     *
     * @param fileOut
     *                The fileOut to set
     */
    public void setFileOut(String fileOut) {
        this.fileOut = fileOut;
    }

    /**
     * @return
     */
    public long getFileDate() {
        return fileDate;
    }

    /**
     * @param l
     */
    public void setFileDate(long l) {
        fileDate = l;
    }

}
