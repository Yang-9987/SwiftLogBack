# SwiftLogBack
A log framework in Swift. It just like logback in Spring. You can config by a json file to customize your log format and other configuration.

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
This is a example of config file:
```json
{
    "logLevel": "info",
    "appenders": [
        {
            "type": "ConsoleAppender",
            "format": "%date %level %metadata %fileLine %n %message %n",
            "charset": "UTF-8",
            "logLevel": "info"
        },
        {
            "type": "FileAppender",
            "format": "%date %level %metadata %fileLine %n %message %n",
            "charset": "UTF-8",
            "logLevel": "info",
            "filePath": "log/logfile.log"
        },
        {
            "type": "RollingFileAppender",
            "format": "%date %level %metadata %fileLine %n %message %n",
            "charset": "UTF-8",
            "logLevel": "info",
            "filePath": "log/logfile.log",
            "rollingPolicy": {
                "type": "timeBased",
                "interval": "daily",
                "maxRetentionDays": 7
            }
        }
    ]
}
```

# Notice
The RollingFileAppender is developing now. It will be finished soon.

# Contact Email And Wechat
This is my first open source, if you have any idea or advice please tell me [1013404703@qq.com]. I will try my best to do it!
I also want to do more interesting things with you! My wechat is yjq9987, welcome to add me!
