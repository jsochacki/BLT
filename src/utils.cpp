#include <algorithm>

#include <opencv2/core/utility.hpp>
#include <opencv2/core/utils/filesystem.hpp>

#include "utils.hpp"



std::string BLT::getFilename(std::string filePath) {
    const std::string parent = cv::utils::fs::getParent(filePath);
    const std::size_t parentLength = parent.length();
    return filePath.substr(parentLength + 1);
}

std::size_t BLT::getImages(std::string imageFolder, 
        std::vector<std::string>& imagePaths) {
    
    // Valid extensions, not case-sensative
    std::string VALID_IMAGE_EXTS[] = {"jpeg", "jpg", "gif", "tiff", "png"};

    std::vector<std::string> allFiles;
    cv::utils::fs::glob(imageFolder, "*", allFiles);

    for(std::string imagePath: allFiles) {
        std::size_t dotIndex = imagePath.rfind('.', imagePath.length());
        
        // Check for the existance of the dot
        if(dotIndex == std::string::npos)
            continue;

        // Get the extension in lower case
        std::string extension = imagePath.substr(dotIndex + 1);
        std::transform(extension.begin(), extension.end(), extension.begin(),
                [](unsigned char c){ return std::tolower(c); });

        // Check if in array of valid image extensions
        std::string* found = std::find(std::begin(VALID_IMAGE_EXTS),
                std::end(VALID_IMAGE_EXTS), extension);
        if(found == std::end(VALID_IMAGE_EXTS))
            continue;
        
        imagePaths.push_back(imagePath);
    }

    return imagePaths.size();
}
