/**
 * This file contains general utility functions needed for the application.
 * 
 * @author Collin Bolles
 */
#ifndef _BLT_UTILS_H_
#define _BLT_UTILS_H_

namespace BLT {
    /**
     * Handles extracting the filename from a UNIX style path.
     * ex) ~/samples/image.jpg => image.jpg
     *
     * @param filePath The whole path of the file
     * @return The image name without the rest of the path
     */
    std::string getFilename(std::string filePath);
}

#endif
