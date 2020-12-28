#include <iostream>
#include <opencv2/core/utility.hpp>
#include <opencv2/core/utils/filesystem.hpp>

#define CANNY_EDGE_OUTPUT "canny/"

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

    return 0;
}
