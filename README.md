#MCKillSwitch.iOS
MCKillSwitch is the official kill switch to use with Mirego’s backend implementation (see API Specs).


##Using

Keep a strong instance of `MCKillSwitchAlert` in your class. The alert will be the delegate of the kill switch.

```
@property (nonatomic, strong) MCKillSwitchAlert *killSwitchAlert;
```

Then execute the kill switch when needed.


``` 
NSURL *baseURL = [NSURL URLWithString:@"http://api.project.com"];

MCKillSwitch *killSwitch = [[MCKillSwitch alloc] initWithBaseURL:baseURL];
killSwitch.delegate = _killSwitchAlert;
[killSwitch execute];

```
