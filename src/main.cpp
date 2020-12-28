#include <iostream>
#include <opencv2/core/utility.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/core/utils/filesystem.hpp>
#include <filesystem>
#include <string>

#define CANNY_EDGE_OUTPUT "canny/"

/**
 * Handles running the Canny Edge detection on all images in the source
 * directory. Each image that has canny edge run on will be output into
 * the outputDir with the same name as the input image.
 *
 * @param sourceDir The source directory for images to run canny edge on
 * @param outputDir Directory to output canny edge images
 */
void runCannyEdge(const std::string& sourceDir, const std::string& outputDir);

int main(int argc, char** argv) {
    
    // Parse command line arguments
    const std::string commandlineKeys = 
        "{help h usage ?    |           |Print the help message           }"
        "{src s             |images/    |Source images to run detection on}"
        "{out o             |out/       |Output image directory           }";
    cv::CommandLineParser parser(argc, argv, commandlineKeys);

    // Check for help message
    if(parser.has("help")) {
        parser.printMessage();
        return 0;
    }

    // Ensure that the source folder exists
    const std::string sourceDir = parser.get<std::string>("src");
    if(!cv::utils::fs::exists(sourceDir)) {
        std::cout << sourceDir << " does not exist" << std::endl;
        return 0;
    }
    else if(!cv::utils::fs::isDirectory(sourceDir)) {
        std::cout << sourceDir << " is not a directory" << std::endl;
        return 0;
    }

    // Create folder for all outputs
    const std::string outputDir = parser.get<std::string>("out");
    if(!cv::utils::fs::exists(outputDir)) {
        std::cout << "Creating Directory: " << outputDir << std::endl;
        cv::utils::fs::createDirectory(outputDir);
    }
    else if(!cv::utils::fs::isDirectory(outputDir)) {
        std::cout << outputDir << " needs to be a directory" << std::endl;
        return 0;
    }

    // Create folder for canny edge outputs
    const std::string cannyOutputs = outputDir + CANNY_EDGE_OUTPUT;
    if(!cv::utils::fs::exists(cannyOutputs)) {
        std::cout << "Creating Directory: " << cannyOutputs << std::endl;
        cv::utils::fs::createDirectory(cannyOutputs);
    }
    else if(!cv::utils::fs::isDirectory(cannyOutputs)) {
        std::cout << cannyOutputs << " needs to be a directory" << std::endl;
        return 0;
    }

    // Run canny edge on all images in source folder
    runCannyEdge(sourceDir, cannyOutputs);
    return 0;
}


void runCannyEdge(const std::string& sourceDir, const std::string& outputDir) {
    // Generate all images to search through
    std::vector<std::string> imagePaths;

    // TODO: Improve globbing for supported image extensions
    cv::utils::fs::glob(sourceDir, "*", imagePaths);
    std::cout << "Files Found in " + sourceDir  + " " << +imagePaths.size() << std::endl;

    cv::Mat original, greyscale, blur, edge;

    for(std::string& imagePath: imagePaths) {
        // Ignore gitkeep, not needed if better globbing used
        if(imagePath.find(".gitkeep") != std::string::npos)
            continue;

        // Load original image
        original = cv::imread(imagePath, cv::IMREAD_COLOR);

        // Convert to greyscale and blur
        cv::cvtColor(original, greyscale, cv::COLOR_BGR2GRAY);
        cv::blur(greyscale, blur, cv::Size(3, 3));

        // Run canny edge
        cv::Canny(blur, edge, 0, 3);

        // Parse out image name and get file to save image to
        const std::string parent = cv::utils::fs::getParent(imagePath);
        const std::size_t parentLength = parent.length();
        const std::string imageName = imagePath.substr(parentLength + 1);
        const std::string output = cv::utils::fs::join(outputDir, imageName);
        
        // Write out result
        cv::imwrite(output, edge);
    }
    


}
