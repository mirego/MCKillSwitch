#MCKillSwitch

MCKillSwitch is the official kill switch to use with Mirego’s backend implementation (see API Specs).

##Using

Keep a strong instance of `MCKillSwitchAlert` in your class. The alert will be the delegate of the kill switch.

```objc
@property (nonatomic) MCKillSwitchAlert *killSwitchAlert;
```

Then execute the kill switch when needed.

```objc
NSURL *baseURL = [NSURL URLWithString:@"http://api.project.com"];

MCKillSwitch *killSwitch = [[MCKillSwitch alloc] initWithBaseURL:baseURL];
killSwitch.delegate = _killSwitchAlert;
[killSwitch execute];

```

##Button Types

###URL
You can specify an URL like this:

Open URL in Safari:
```
"type": "url",
"label": "Upgrade",
"url": "http://google.com"
```

Open AppStore directly in the current app:
```
"type": "url",
"label": "Upgrade",
"url": "store:507874739"
```

## Adding to your project

If you're using [`CocoaPods`](http://cocoapods.org/), there's nothing simpler.
Add the following to your [`Podfile`](http://docs.cocoapods.org/podfile.html)
and run `pod install`

```ruby
pod 'MCKillSwitch', :git => 'https://github.com/mirego/MCKillswitch.git'
```

## License

MCKillSwitch is © 2013-2017 [Mirego](http://www.mirego.com) and may be freely
distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).
See the [`LICENSE`](https://github.com/mirego/MCKillSwitch/blob/master/LICENSE) file.

## About Mirego

[Mirego](http://mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're a team of [talented people](http://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](http://open.mirego.com) and we try to give back to the community as much as we can.
