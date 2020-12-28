#include <iostream>
#include <opencv2/core/utility.hpp>
#include <opencv2/core/utils/filesystem.hpp>

int main(int argc, char** argv) {
    
    // Parse command line arguments
    const std::string commandlineKeys = 
        "{help h usage ?    |           |Print the help message           }"
        "{src s             |images/src/|Source images to run detection on}";
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
    }
    else if(!cv::utils::fs::isDirectory(sourceDir)) {
        std::cout << sourceDir << " is not a directory" << std::endl;
    }


    return 0;
}
