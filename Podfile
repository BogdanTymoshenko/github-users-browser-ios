platform :ios, '9.0'
use_frameworks!

target 'GitHubU' do
    # Network
    pod 'Alamofire', '~> 4.3'
    pod 'AlamofireImage', '~> 3.2.0'

    # RxSwift
    pod 'RxSwift', '~> 3.2.0'
    pod 'RxCocoa', '~> 3.2.0'

    # Json
    pod 'SwiftyJSON', '~> 3.1.4'

    # UI
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'DZNEmptyDataSet', '~> 1.8.1'

    target 'GitHubUTests' do
        inherit! :complete

        # Pods for testing
        # Mocks
        pod 'Cuckoo'
        pod 'RxTest', '~> 3.2.0'
    end

    target 'GitHubUUITests' do
        inherit! :search_paths
        # Pods for testing
    end
end
