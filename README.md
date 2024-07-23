# SwiftLogBack
A log framework. Just like logback in Spring. You can config by a json file to customize your log format and many things.

# How to use
```swift
let url = "/xxx/logConfig.json" // where your config file is
let fileURL = URL(fileURLWithPath: url)
do {
    if let config = loadConfig(configUrl: fileURL) {
        try configToLoggingSystem(config: config)
    } else {
        print("cannot load config file")
    }
} catch {
    print("Failed to load file appender: \(error)")
}
```

# How to write config json file
```swift
Writing...
```

# Email
This is my first open source, if you have any idea or advice please tell me [1013404703@qq.com]. I will try my best to do it!
