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

## Adding to your project

If you're using [`CocoaPods`](http://cocoapods.org/), there's nothing simpler.
Add the following to your [`Podfile`](http://docs.cocoapods.org/podfile.html)
and run `pod install`

```ruby
pod 'MCKillSwitch', :git => 'https://github.com/mirego/MCKillswitch.git'
```

## License

MCKillSwitch is © 2013-2015 [Mirego](http://www.mirego.com) and may be freely
distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).
See the [`LICENSE`](https://github.com/mirego/MCKillSwitch/blob/master/LICENSE) file.

## About Mirego

Mirego is a team of passionate people who believe that work is a place where you can innovate and have fun.
We proudly built mobile applications for
[iPhone](http://mirego.com/en/iphone-app-development/ "iPhone application development"),
[iPad](http://mirego.com/en/ipad-app-development/ "iPad application development"),
[Android](http://mirego.com/en/android-app-development/ "Android application development"),
[Blackberry](http://mirego.com/en/blackberry-app-development/ "Blackberry application development"),
[Windows Phone](http://mirego.com/en/windows-phone-app-development/ "Windows Phone application development") and
[Windows 8](http://mirego.com/en/windows-8-app-development/ "Windows 8 application development").
