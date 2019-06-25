import SwiftShell
import Yaml
import Ocha
import PathKit
import Commander
import Foundation


if let pwd = ProcessInfo.processInfo.environment["DEBUG_PWD"] {
    SwiftShell.main.currentdirectory = pwd
}
let currentWorkingDirectory = SwiftShell.main.currentdirectory

let runner = command { (filePath: String) in
    print("filePath: \(filePath)")
    let config = try YamlConfigReader().read(filePath: filePath)
    print("config: \(config)")
    let infos = ConfigurationTranslator(
        extractor: FilePathExtractor(),
        sourcePathCollector: FilePathCollector(baseFilePath: currentWorkingDirectory, accessor: \.sourcePaths),
        ignorePathCollector: FilePathCollector(baseFilePath: currentWorkingDirectory, accessor: \.ignoredPaths)
        )
        .translate(config: config)
    print("infos: \(infos)")
    try infos.forEach { try TeapotCommandExecutor().exec(information: $0) }
}

runner.run()
