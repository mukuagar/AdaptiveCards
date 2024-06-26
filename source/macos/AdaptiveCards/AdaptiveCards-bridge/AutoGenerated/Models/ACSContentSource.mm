// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSRemoteResourceInformationConvertor.h"

//cpp includes
#import "RemoteResourceInformation.h"


#import "ACSContentSource.h"
#import "ContentSource.h"



@implementation  ACSContentSource {
    std::shared_ptr<ContentSource> mCppObj;
}

- (instancetype _Nonnull)initWithContentSource:(const std::shared_ptr<ContentSource>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSString * _Nullable)getMimeType
{
 
    auto getMimeTypeCpp = mCppObj->GetMimeType();
    return [NSString stringWithUTF8String:getMimeTypeCpp.c_str()];

}

- (void)setMimeType:(NSString * _Nonnull)value
{
    auto valueCpp = std::string([value UTF8String]);
 
    mCppObj->SetMimeType(valueCpp);
    
}

- (NSString * _Nullable)getUrl
{
 
    auto getUrlCpp = mCppObj->GetUrl();
    return [NSString stringWithUTF8String:getUrlCpp.c_str()];

}

- (void)setUrl:(NSString * _Nonnull)value
{
    auto valueCpp = std::string([value UTF8String]);
 
    mCppObj->SetUrl(valueCpp);
    
}

- (void)getResourceInformation:(NSArray<ACSRemoteResourceInformation *>* _Nonnull)resourceInfo
{
    std::vector<AdaptiveCards::RemoteResourceInformation> resourceInfoVector;
    for (id resourceInfoObj in resourceInfo)
    {
        resourceInfoVector.push_back([ACSRemoteResourceInformationConvertor convertObj:resourceInfoObj]);
    }

 
    mCppObj->GetResourceInformation(resourceInfoVector);
    
}




@end