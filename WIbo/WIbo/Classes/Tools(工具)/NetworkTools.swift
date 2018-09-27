//
//  NetworkTools.swift
//  HTTP:  NSAppTransportSecurity --> NSAllowsArbitraryLoads <true>


import AFNetworking

// 定义枚举类型
enum RequestType{
    case GET
    case POST
}


// API结构被定义为定义各种网络接口
struct API {
    // Define hostname
    static let hostName = ""
    // Define baseURL
    static let baseURL = ""
}


class NetworkTools: AFHTTPSessionManager {
    // let是线程安全的 static:静态
    // 单例
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        
        let setArr = NSSet(objects: "text/html", "application/json", "text/json", "text/plain")
        tools.responseSerializer.acceptableContentTypes = setArr as? Set<String>
        
        // add HttpHeader
//        tools.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        tools.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
//        
//        tools.requestSerializer.willChangeValue(forKey: "timeoutInterval")
//        tools.requestSerializer.timeoutInterval = 30.0
//        tools.requestSerializer.didChangeValue(forKey: "timeoutInterval")
        return tools
        
    }()
}

/**
  定义了一种对外开放的方法来请求网络数据
 - parameter methodType:        request type(GET / POST) 请求类型
 - parameter urlString:         url address
 - parameter parameters:
   发送网络所需的参数          request is a dictionary.
 - parameter successBlock:     完成回调
 - parameter failureBlock:    返回请求数据的回调参数
 - parameter error:          如果请求成功，则错误为零。
 */

// MARK:- 封装请求方法
extension NetworkTools{
    func   request(methodType : RequestType ,urlSring : String, parameters: [String: Any],finished : @escaping (Any?, Error?) -> ()){
        
        //请求成功，则错误为零。
        let successBlock = { (task : URLSessionDataTask, result :Any?) in
            finished(result, nil)
        }
        
        let failureBlock = { (task : URLSessionDataTask?, error : Error) in
            finished(nil,error)
        }

        if methodType == .GET{
            get(urlSring, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }else{
            post(urlSring, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }

    }
}

// MARK:- 请求AccessToken
extension NetworkTools {
    func  loadAccessToken(code : String, finished : @escaping ([String: Any]?, Error?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 2.获取请求的参数
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri, "code" : code]
        
        // 3.发送网络请求
        request(methodType: .POST, urlSring: urlString, parameters: parameters) { (result , error) in
            finished(result as? [String : AnyObject] , error)
        }
    }
}

// MARK:- 请求用户的信息
extension NetworkTools {
    func loadUserInfo(access_token : String, uid : String, finished : @escaping ([String: Any]?, Error?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : access_token, "uid" : uid]
        // 3.发送网络请求
        request(methodType: .GET, urlSring: urlString, parameters: parameters) { (result, error) in
            finished(result as? [String : AnyObject] , error)
        }
    }
}
