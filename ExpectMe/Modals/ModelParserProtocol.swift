import Foundation

protocol ModelParserProtocol{
    
    func objectFromJSON (json: NSDictionary) -> (Self)
    
}
