# Flutter Evernym Mobile SDK ( DID )
## Overview
Evernym Mobile SDK를 Flutter로 컨버팅한 라이브러리

## 🛠 Prerequisite

|      NAME      | VERSION |
|:--------------:|:-------:|
|  Flutter SDK   |  3.7.7  |

## How To Use
### 라이브러리를 사용하는 프로젝트의 ios/Runner/Podfile 에 다음을 추가
#### source ( pod default repo, evernym-mobile sdk git repo )

``` Podfile
# pod default repo ( 다른 git repo를 사용하려면 default repo도 명시 해줘야 함 )
source 'https://github.com/CocoaPods/Specs.git'

# evernym-mobile sdk git repo
source 'https://gitlab.com/evernym/mobile/mobile-sdk.git'
```
#### pod vcx

``` Podfile
   # evernym-mobile sdk
   pod 'vcx', '0.0.227'
```
#### target 설정

``` Podfile
   # evernym-mobile sdk
    if target.name == "vcx"
           target.build_configurations.each do |config|
               config.build_settings['ENABLE_BITCODE'] = 'NO'
           end
    end
```
#### 설정 이후
```
pod install --repo-update
```

### 전체 Podfile
``` Podfile
...
...
# pod default repo ( 다른 git repo를 사용하려면 default repo도 명시 해줘야 함 )
source 'https://github.com/CocoaPods/Specs.git'

# evernym-mobile sdk git repo
source 'https://gitlab.com/evernym/mobile/mobile-sdk.git'

...
...

target 'Runner' do
  use_frameworks!
  use_modular_headers!

   # evernym-mobile sdk
   pod 'vcx', '0.0.227'
   
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    # evernym-mobile sdk
    if target.name == "vcx"
           target.build_configurations.each do |config|
               config.build_settings['ENABLE_BITCODE'] = 'NO'
           end
    end
  end
end

```
