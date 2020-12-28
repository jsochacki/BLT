#include <iostream>

#include <opencv2/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/core/utility.hpp>
#include <opencv2/core/utils/filesystem.hpp>

#include "processing.hpp"
#include "utils.hpp"

void BLT::runCanny(const std::string srcDir, const std::string outDir, 
        const double blurSize, const double thresold1, const double thresold2) {

    // Generate all images to search through
    std::vector<std::string> imagePaths;
    std::size_t foundImages = BLT::getImages(srcDir, imagePaths);
    std::cout << "Images Found: " << +foundImages << std::endl;

    cv::Mat original, greyscale, blur, edge;

    for(std::string& imagePath: imagePaths) {
        // Ignore gitkeep, not needed if better globbing used.
        if(imagePath.find(".gitkeep") != std::string::npos)
            continue;

        // Load original image
        original = cv::imread(imagePath, cv::IMREAD_COLOR);

        // Convert to greyscale and blur
        cv::cvtColor(original, greyscale, cv::COLOR_BGR2GRAY);
        cv::blur(greyscale, blur, cv::Size(blurSize, blurSize));

        // Run canny edge
        cv::Canny(blur, edge, thresold1, thresold2);

        // Save edge
        const std::string imageName = BLT::getFilename(imagePath);
        const std::string output = cv::utils::fs::join(outDir, imageName);
        cv::imwrite(output, edge);
    }
}
