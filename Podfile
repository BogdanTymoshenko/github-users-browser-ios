platform :ios, '9.0'
use_frameworks!

target 'GitHubU' do
    # Network
    pod 'Alamofire', '~> 4.3'
    pod 'AlamofireImage', '~> 3.2.0'

    # RxSwift
    pod 'RxSwift', '~> 3.2.0'
    pod 'RxCocoa', '~> 3.2.0'
    #pod 'RxAlamofire', '~> 3.0.2'

    # Json
    pod 'SwiftyJSON', '~> 3.1.4'

    # UI
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'DZNEmptyDataSet', '~> 1.8.1'
    pod 'Whisper', '~> 4.0.0'

    target 'GitHubUTests' do
        inherit! :complete

        # Pods for testing
        # Mocks
        pod "Cuckoo"
    end

    target 'GitHubUUITests' do
        inherit! :search_paths
        # Pods for testing
    end
end
