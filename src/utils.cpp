#include <opencv2/core/utility.hpp>
#include <opencv2/core/utils/filesystem.hpp>

#include "utils.hpp"

std::string BLT::getFilename(std::string filePath) {
    const std::string parent = cv::utils::fs::getParent(filePath);
    const std::size_t parentLength = parent.length();
    return filePath.substr(parentLength + 1);
}
