//
//  APIDefine.m
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/23/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "APIDefine.h"

@implementation APIDefine

+(Environment)getEnvironment {
    return DEVELOPMENT;
}

+(NSString *)getrootURL
{
    NSString* result;
    switch ([APIDefine getEnvironment]) {
        case DEVELOPMENT:
            result=@"http://dev.apis.bloomerapp.vn:8181/bloomer_apis/"; //DEV
            break;
        case STAGING:
            result=@"https://staging-apis.bloomerapp.com/bloomer_apis/"; //STAGING
            break;
        default:
            result=@"https://apis.bloomerapp.com/bloomer_apis/"; //AMAZON
            break;
    }
    return result;
    
}

+(NSString *)getrootWebURL
{
    NSString* result;
    switch ([APIDefine getEnvironment]) {
        case DEVELOPMENT:
            result=@"http://dev.apis.bloomerapp.vn/"; //DEV
            break;
        default:
            result=@"https://bloomerapp.com/"; //AMAZON
            break;
    }
    return result;
}

+(NSString *)getChatRootURL
{
    NSString* result;
    switch ([APIDefine getEnvironment]) {
        case DEVELOPMENT:
            result=@"http://dev.messages.bloomerapp.vn:8181/bloomer_chat/"; //DEV
            break;
        default:
            result=@"https://messages.bloomerapp.com/bloomer_chat/"; //AMAZON
            break;
    }
    return result;
}

+(NSString *)getPhotoRootURL
{
    NSString* result;
    switch ([APIDefine getEnvironment]) {
        case DEVELOPMENT:
            result=@"http://dev.photos.bloomerapp.vn:8181/bloomer_photos/"; //DEV
            break;
        case STAGING:
            result=@"https://staging-photos.bloomerapp.com/bloomer_photos/"; //STAGING
            break;
        default:
            result=@"https://photos.bloomerapp.com/bloomer_photos/"; //AMAZON
            break;
    }
    return result;
}

+ (NSString*)shareInviteCodeLink
{
    return [[self getrootWebURL] stringByAppendingString:@"download/?lang=vi&invitecode="];
}

+ (RequestURL *)auth_authorizeLink//http://dev.apis.bloomerapp.vn:8181/bloomer_apis/oauth/auth.authentication
{
//    return [[self getrootURL] stringByAppendingString:@"oauth/auth.authentication"];
    return [[RequestURL alloc] initWithURL:@"oauth/auth.authentication" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)auth_logoutLink
{
//    return [[self getrootURL] stringByAppendingString:@"oauth/auth.logout?access_token=...&device_id=..."];
    return [[RequestURL alloc] initWithURL:@"oauth/auth.logout" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)race_fetchesLink//http://dev.apis.bloomerapp.vn:8181/bloomer_apis/api/race.get
{
    // api/race.get?access_token=...&device_id=...&key=...&ckey=...&rank=...&is_refresh=...&gender=...
    return [[RequestURL alloc] initWithURL:@"api/race.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)races_surprise_fetechesLink {
    // api/race.surprise.me?access_token=...&device_id=...&key=...&ckey=...&gender=...
    return [[RequestURL alloc] initWithURL:@"api/race.surprise.me" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)races_MyRank_fetchesLink {
    // api/race.myrank.load?access_token=...&device_id=...&key=...&ckey=...
    return [[RequestURL alloc] initWithURL:@"api/race.myrank.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)race_banner_fetchesLink {
//    return [[self getrootURL] stringByAppendingString:@"api/race.banner.load?access_token=...&device_id=...&gender=...&key=...&ckey=..."];
    return [[RequestURL alloc] initWithURL:@"api/race.banner.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)profile_fetchBlockerLink {
//    return [[self getrootURL] stringByAppendingString:@"follow/blocker.load?access_token=...&device_id=..."];
    return [[RequestURL alloc] initWithURL:@"follow/blocker.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)race_tag_fetchLink {
    // api/racename.get.tagged?access_token=...&device_id=...
    return [[RequestURL alloc] initWithURL:@"api/racename.get.tagged" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)race_gallery_fetchesLink { // get all posts of Race ; postID for load more
//    return [[self getrootURL] stringByAppendingString:@"api/gallery.race.get?access_token=...&device_id=...&key=...&gender=...&post_id=...&limit=..."];
    return [[RequestURL alloc] initWithURL:@"api/gallery.race.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)races_search_fetchesLink {
    return [[RequestURL alloc] initWithURL:@"api/race.v2.search" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)post_followers_fetchLink {
//    return [[self getrootURL] stringByAppendingString:@"follow/follower.post.get?access_token=...&device_id=...&post_id=...&index=..."];
    return [[RequestURL alloc] initWithURL:@"follow/follower.post.get" Host:[self getrootURL] requestMethod:GET];
}


+ (RequestURL *)profile_post_galleryLink { // get all posts of race on user ; postID for load more ; userID for load other profile
//    return [[self getrootURL] stringByAppendingString:@"api/gallery.get?access_token=...&device_id=...&key=...&user_id=...&post_id=...&limit=..."];
    return [[RequestURL alloc] initWithURL:@"api/gallery.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)profile_followerLink {
//    return [[self getrootURL] stringByAppendingString:@"follow/follower.get?access_token=...&device_id=...&user_id=...&limit=...&st=..."];
    return [[RequestURL alloc] initWithURL:@"follow/follower.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)profile_followingLink {
//    return [[self getrootURL] stringByAppendingString:@"follow/following.get?access_token=...&device_id=...&user_id=...&limit=...&st=..."];
    return [[RequestURL alloc] initWithURL:@"follow/following.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)profile_searchFllower
{
//    return [[self getrootURL] stringByAppendingString:@"follow/search.follower?access_token=...&device_id=...&term_search=..."];
    return [[RequestURL alloc] initWithURL:@"follow/search.follower" Host:[self getrootURL] requestMethod:GET];
}
+ (RequestURL *)profile_searchFllowing
{
//    return [[self getrootURL] stringByAppendingString:@"follow/search.following?access_token=...&device_id=...&term_search=..."];
    return [[RequestURL alloc] initWithURL:@"follow/search.following" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)race_name_fetchLink {//http://dev.apis.bloomerapp.vn:8181/bloomer_apis/api/racename.get
    // api/racename.get?access_token=...&device_id=...&key=...&isNew=...
    return [[RequestURL alloc] initWithURL:@"api/racename.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)getRaceList {
    return [[RequestURL alloc] initWithURL:@"api/racename.get.active" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)race_favourites_oneLink {
    // @"api/race.favorites.one?access_token=..&device_id=...&min=...&max=..."
    return [[RequestURL alloc] initWithURL:@"api/race.favorites.one" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)user_feed_fetchesLink {
    return [[RequestURL alloc] initWithURL:@"service/feeds" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)race_feed_fetchesLink {
    return [[RequestURL alloc] initWithURL:@"api/feed.raceclosed.load" Host:[self getrootURL] requestMethod:GET];
}

// MARK: - DISCOVERY

// http://dev.apis.bloomerapp.vn:8181/bloomer_apis/service/discovery.load
+ (RequestURL *)discovery_fetchesLink {
    return [[RequestURL alloc] initWithURL:@"service/discovery.v2.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)discovery_searchLink {
    return [[RequestURL alloc] initWithURL:@"service/search.discovery.full" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)post_user_fetchesLink {
    return [[RequestURL alloc] initWithURL:@"service/posts" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)get_FeedLink{
    return [[RequestURL alloc] initWithURL:@"service/feed.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)post_createLink
{
//    return [[self getrootURL] stringByAppendingString:@"service/feed.create"];
    return [[RequestURL alloc] initWithURL:@"service/feed.create" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)post_fetch_postsLink
{
//    return [[self getrootURL] stringByAppendingString:@"social/post.fetch.posts?access_token=...&min=...&max=...&post_id=..."];
    return [[RequestURL alloc] initWithURL:@"social/post.fetch.posts" Host:[self getrootURL] requestMethod:GET];
}
+ (RequestURL *)post_fetch_posts_userLink
{
    return [[RequestURL alloc] initWithURL:@"social/post.fetch.posts-user" Host:[self getrootURL] requestMethod:GET];
}
+ (RequestURL *)post_fetch_a_postLink
{
//    return [[self getrootURL] stringByAppendingString:@"social/post.fetch.a-post?post_id=...&access_token=..&device_id=...&cmin=...&cmax=..."];
    return [[RequestURL alloc] initWithURL:@"social/post.fetch.a-post" Host:[self getrootURL] requestMethod:GET];
}
+ (RequestURL *)post_commentLink;
{
//    return [[self getrootURL] stringByAppendingString:@"service/post.comment"];
    return [[RequestURL alloc] initWithURL:@"service/post.comment" Host:[self getrootURL] requestMethod:POST];
}
+ (RequestURL *)post_comments_fetchLink
{
//    return [[self getrootURL] stringByAppendingString:@"service/post.comment.load?access_token=...&device_id=...&post_id=...&comment_id=..."];
    return [[RequestURL alloc] initWithURL:@"service/post.comment.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)auth_checkMobileLinkFacebook
{
    return [[RequestURL alloc] initWithURL:@"account/auth.check_mobile_linkfb" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_updateLink
{
//    return [[self getrootURL] stringByAppendingString:@"account/profile.update"];
    return [[RequestURL alloc] initWithURL:@"account/profile.update" Host:[self getrootURL] requestMethod:POST];
}
+ (RequestURL *)profile_update_about_meLink
{
//    return [[self getrootURL] stringByAppendingString:@"account/profile.update.about-me"];
    return [[RequestURL alloc] initWithURL:@"account/profile.update.about-me" Host:[self getrootURL] requestMethod:POST];
}
+ (RequestURL *)profile_locationLink {
    return [[RequestURL alloc] initWithURL:@"account/profile.change.location" Host:[self getrootURL] requestMethod:PUT];
}

+ (RequestURL *)profile_Block_Link {
    return [[RequestURL alloc] initWithURL:@"follow/block.add" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_unBlock_newLink {
    return [[RequestURL alloc] initWithURL:@"follow/block.remove" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_unFollowLink {
    return [[RequestURL alloc] initWithURL:@"follow/following.unfollow" Host:[self getrootURL] requestMethod:PUT];
}

+ (RequestURL *)profile_reFollowLink {
    return [[RequestURL alloc] initWithURL:@"follow/following.follow" Host:[self getrootURL] requestMethod:PUT];
}

+ (RequestURL *)profile_mobileVerifyLink {
//    return [[self getrootURL] stringByAppendingString:@"account/profile.update.mobile.verify"];
    return [[RequestURL alloc] initWithURL:@"account/profile.update.verify.mobile" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)reportLink {
//    return [[self getrootURL] stringByAppendingString:@"reports/report.post"];
    return [[RequestURL alloc] initWithURL:@"reports/report.post" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)reportUserLink {
    return [[RequestURL alloc] initWithURL:@"reports/report.user" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)flower_givingPopupLink{
    return [[RequestURL alloc] initWithURL:@"message/get.popup.dailygiveflower" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)profile_genderLink {
    return [[RequestURL alloc] initWithURL:@"account/profile.change.gender" Host:[self getrootURL] requestMethod:PUT];
}

+ (RequestURL *)profile_checkPasswordLink {
//    return [[self getrootURL] stringByAppendingString:@"account/profile.verify.pass"];
    return [[RequestURL alloc] initWithURL:@"account/profile.verify.pass" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_checkPassUser {
    return [[RequestURL alloc] initWithURL:@"oauth/auth.check_pass_user" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_mobileLink {
    return [[RequestURL alloc] initWithURL:@"account/profile.sendcode.update.mobile" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_emailLink {
    return [[RequestURL alloc] initWithURL:@"account/profile.update.email" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_updateBirthday {
    return [[RequestURL alloc] initWithURL:@"account/profile.update.birthday" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_notiSettingLink {
//    return [[self getrootURL] stringByAppendingString:@"account/profile.setting.notification"];
    return [[RequestURL alloc] initWithURL:@"account/profile.setting.notification" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_privateShareLink {
    return [[RequestURL alloc] initWithURL:@"account/profile.update.allowshare" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_New_fetchLink
{
//    return [[self getrootURL] stringByAppendingString:@"account/profile.user.fetch.v2.5?access_token=...&device_id=...&user_id=..."];
    return [[RequestURL alloc] initWithURL:@"account/profile.user.fetch.v2.5" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)profile_galleryLink {
//    return [[self getrootURL] stringByAppendingString:@"api/galleries.get?access_token=...&device_id=...&user_id=..."];
    return [[RequestURL alloc] initWithURL:@"api/galleries.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)reason_fetchLink {
    // @"static/reports.reasons?type=..."
    return [[RequestURL alloc] initWithURL:@"static/reports.reasons" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)profile_postLink {
//    return [[self getrootURL] stringByAppendingString:@"account/profile.posts.load?access_token=...&device_id=...&user_id=...&post_id=..."];
    return [[RequestURL alloc] initWithURL:@"account/profile.posts.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)profile_avatarsLink {
//    return [[self getrootURL] stringByAppendingString:@"account/profile.avatar.load?access_token=...&device_id=..."];
    return  [[RequestURL alloc] initWithURL:@"account/profile.avatar.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)content_post_fetchesLink {
//    return [[self getrootURL] stringByAppendingString:@"service/post.get?access_token=...&device_id=...&post_id=..."];
    return [[RequestURL alloc] initWithURL:@"service/post.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)isChat_fetchLink
{
    return [[RequestURL alloc] initWithURL:@"service/v2/ischat" Host:[self getrootURL] requestMethod:GET];
}
+ (RequestURL *)profile_meLink//http://dev.apis.bloomerapp.vn:8181/bloomer_apis/account/profile.fetch
{
//    return [[self getrootURL] stringByAppendingString:@"account/profile.fetch?access_token=...&device_id=..."];
    return [[RequestURL alloc] initWithURL:@"account/profile.fetch" Host:[self getrootURL] requestMethod:GET];
}
+ (RequestURL *)profile_settingLink
{
//    return [[self getrootURL] stringByAppendingString:@"account/profile.fetch.setting?access_token=...&device_id=..."];
    return [[RequestURL alloc] initWithURL:@"account/profile.fetch.setting" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)profile_setting_fetchesLink {
//    return [[self getrootURL] stringByAppendingString:@"account/profile.setting.fetch?access_token=...&device_id=..."];
    return [[RequestURL alloc] initWithURL:@"account/profile.setting.fetch" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)profile_addLocation
{
    return [[RequestURL alloc] initWithURL:@"account/profile.add.location" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)popup_topCountry
{
    return [[RequestURL alloc] initWithURL:@"message/popup.topwinners" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)getTopWinnersLink {
    return [[RequestURL alloc] initWithURL:@"message/popup.topwinners" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)getRaceMoreScrollLink {
    return [[RequestURL alloc] initWithURL:@"api/race.more.scroll" Host:[self getrootURL] requestMethod:GET];
}

#pragma mark - Giving Flower
+ (RequestURL *)profile_bannerLink {
//    return [[self getrootURL] stringByAppendingString:@"account/profile.banner.load?access_token=...&device_id=...&user_id=..."];
    return [[RequestURL alloc] initWithURL:@"account/profile.banner.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)flower_giveLink
{
//    return [[self getrootURL] stringByAppendingString:@"api/flower.give"];
    return [[RequestURL alloc] initWithURL:@"api/flower.give" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)flower_give_profileLink {
//    return [[self getrootURL] stringByAppendingString:@"api/flower.give.profile"];
    return [[RequestURL alloc] initWithURL:@"api/flower.give.profile" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)flower_give_postLink {
//    return [[self getrootURL] stringByAppendingString:@"api/flower.give.post"];
    return [[RequestURL alloc] initWithURL:@"api/flower.give.post" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)sponsor_fetchLink
{
//    return [[self getrootURL] stringByAppendingString:@"sponsor/sponsors.fetch?access_token=...&device_id=...&user_id=..."];
    return [[RequestURL alloc] initWithURL:@"sponsor/sponsors.fetch" Host:[self getrootURL] requestMethod:GET];
}
+ (RequestURL *)sponsor_post_fetchLink
{
//    return [[self getrootURL] stringByAppendingString:@"sponsor/sponsors.post.fetch?access_token=...&device_id=...&post_id=...&min=...&max=..."];
    return [[RequestURL alloc] initWithURL:@"sponsor/sponsors.post.fetch" Host:[self getrootURL] requestMethod:GET];
}

#pragma mark - Photo-Avarta-Image
+ (RequestURL *)avatar_attachedLink//http://dev.apis.bloomerapp.vn:8181/bloomer_apis/ajax/attachment/media.photo
{
//    return [[self getPhotoRootURL] stringByAppendingString:@"ajax/attachment/media.photo"];
    return [[RequestURL alloc] initWithURL:@"ajax/attachment/media.photo" Host:[self getPhotoRootURL] requestMethod:POST];
}
+ (RequestURL *)avatar_race_attchedLink {
//    return [[self getPhotoRootURL] stringByAppendingString:@"ajax/attachment/media.avatar"];
    return [[RequestURL alloc] initWithURL:@"ajax/attachment/media.avatar" Host:[self getPhotoRootURL] requestMethod:POST];
}

+(NSString *)hImageLink
{
    return [[self getPhotoRootURL] stringByAppendingString:@"picture/himage/"];
    
}
+(NSString *)hProfileLink
{
    return [[self getPhotoRootURL] stringByAppendingString:@"picture/hprofile-xp-11/"];
}

//+(NSString *)photoLoadLink
//{
//    return [[self getPhotoRootURL] stringByAppendingString:@"picture_v4/himage/"];
//}

+(RequestURL *)payment_buyLink
{
    return [[RequestURL alloc] initWithURL:@"payment/buy.flower" Host:[self getrootURL] requestMethod:POST];
}

+(RequestURL *)galleriesLoadLink
{
//    return [[self getrootURL] stringByAppendingString:@"picture/galaries.load?access_token=...&device_id=...&user_id=..."];
    return [[RequestURL alloc] initWithURL:@"picture/galaries.load" Host:[self getrootURL] requestMethod:GET];
}

#pragma mark - Chat/Message
+ (RequestURL *)auth_registerLink//http://dev.apis.bloomerapp.vn:8181/bloomer_apis/oauth.v2/auth.register
{
    return [[RequestURL alloc] initWithURL:@"oauth/auth.register.info.update" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)message_connectLink
{
//    return [[self getChatRootURL] stringByAppendingString:@"ajax/message.connection"];
    return [[RequestURL alloc] initWithURL:@"ajax/message.connection" Host:[self getChatRootURL] requestMethod:GET];
}

+ (RequestURL *)message_pull_roomLink
{
//    return [[self getChatRootURL] stringByAppendingString:@"ajax/pull.message?room_id=..."];
    return [[RequestURL alloc] initWithURL:@"ajax/pull.message" Host:[self getChatRootURL] requestMethod:GET];
}

+ (RequestURL *)message_pull_rosterLink
{
//    return [[self getChatRootURL] stringByAppendingString:@"ajax/pull.message?roster_id=..."];
    return [[RequestURL alloc] initWithURL:@"ajax/pull.message" Host:[self getChatRootURL] requestMethod:GET];
}

+ (RequestURL *)message_presence_roomLink
{
//    return [[self getChatRootURL] stringByAppendingString:@"ajax/message.presence?room_id=...&mid=..."];
    return [[RequestURL alloc] initWithURL:@"ajax/message.presence" Host:[self getChatRootURL] requestMethod:GET];
}

+ (RequestURL *)message_presence_rosterLink
{
//    return [[self getChatRootURL] stringByAppendingString:@"ajax/message.presence?roster_id=...&mid=..."];
    return [[RequestURL alloc] initWithURL:@"ajax/message.presence" Host:[self getChatRootURL] requestMethod:GET];
}
    

+ (RequestURL *)message_sendLink
{
//    return [[self getChatRootURL] stringByAppendingString:@"ajax/message.send"];
    return [[RequestURL alloc] initWithURL:@"ajax/message.send" Host:[self getChatRootURL] requestMethod:POST];
}

+ (RequestURL *)message_disconnectLink
{
//    return [[self getChatRootURL] stringByAppendingString:@"ajax/message.disconnection"];
    return [[RequestURL alloc] initWithURL:@"ajax/message.disconnection" Host:[self getChatRootURL] requestMethod:GET];
}

// MARK: - CHAT - room
+ (RequestURL*)rooms_fetchLink
{
//    return [[self getrootURL] stringByAppendingString:@"message/rooms.load?access_token=...&device_id=...&room_id=...&limit=..."];
    return [[RequestURL alloc] initWithURL:@"message/rooms.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)room_delete
{
//    return [[self getrootURL] stringByAppendingString:@"message/room.delete"];
    return [[RequestURL alloc] initWithURL:@"message/room.delete" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL*)room_read
{
//    return [[self getrootURL] stringByAppendingString:@"message/room.read"];
    return [[RequestURL alloc] initWithURL:@"message/room.read" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *) auth_sendcodeLink{
    return [[RequestURL alloc] initWithURL:@"oauth/auth.sendcodephonenumber" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)auth_registerInfoLink{
    return [[RequestURL alloc] initWithURL:@"oauth/auth.register.info" Host:[self getrootURL] requestMethod:POST];
}
//Deprecated
+ (RequestURL*)auth_register_sendcodeLink //http://dev.apis.bloomerapp.vn:8181/bloomer_apis/oauth/auth.register.send_code
{                                       //http://dev.apis.bloomerapp.vn:8181/
//    return [[self getrootURL] stringByAppendingString:@"oauth/auth.register.send_code"];
    return [[RequestURL alloc] initWithURL:@"oauth/auth.register.send_code" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)auth_resendcodeLink{
    return [[RequestURL alloc] initWithURL:@"oauth/auth.resendcodephonenumber" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)auth_resendcodeLoginLink{
    return [[RequestURL alloc] initWithURL:@"oauth/auth.resendcodeauthorize" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)auth_resendcodeUpdateLink{
    return [[RequestURL alloc] initWithURL:@"account/profile.resendcode.update.mobile" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)auth_register_callsupportlink{
//    return [[self getrootURL] stringByAppendingString:@"oauth/auth.register.voicecode"];
    return [[RequestURL alloc] initWithURL:@"oauth/auth.register.voicecode" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL*)auth_register_verifycodeLink //http://dev.apis.bloomerapp.vn:8181/bloomer_apis/oauth/auth.register.verify_code
{
//    return [[self getrootURL] stringByAppendingString:@"oauth/auth.register.verify_code"];
    return [[RequestURL alloc] initWithURL:@"oauth/auth.register.verify" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL*)auth_checkpasswordLink{
    return [[RequestURL alloc] initWithURL:@"oauth/auth.check_pass_user" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL*)account_forget_whoLink
{
//    return [[self getrootURL] stringByAppendingString:@"account/account.forget.who"];
    return [[RequestURL alloc] initWithURL:@"account/account.forget.who" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)account_forget_voicecall{
//return [[self getrootURL] stringByAppendingString:@"account/account.forget.voice"];
    return [[RequestURL alloc] initWithURL:@"account/account.forget.voice" Host:[self getrootURL] requestMethod:POST];
}

//+ (NSString*)photo_limit_attachedLink
//{
//    return [[self getPhotoRootURL] stringByAppendingString:@"picture/photo.limit.attached"];
//}

+ (RequestURL*)account_forget_verifycodeLink
{
//    return [[self getrootURL] stringByAppendingString:@"account/account.forget.verify_code"];
    return [[RequestURL alloc] initWithURL:@"account/account.forget.verify_code" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL*)account_forget_changepassLink
{
//    return [[self getrootURL] stringByAppendingString:@"account/account.forget.change_pass"];
    return [[RequestURL alloc] initWithURL:@"account/account.forget.change_pass" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL*)notification_getListUser{
    return [[RequestURL alloc] initWithURL:@"message/noti.getlistuser" Host:[self getrootURL] requestMethod:POST];
}

//+ (NSString*)race_fetches_bymeLink
//{
//    return [[self getrootURL] stringByAppendingString:@"api/v2/race.fetches.byme?access_token=...&device_id=...&irace=..."];
//}

//+ (NSString*)race_fetches_byme_scrollLink
//{
//    return [[self getrootURL] stringByAppendingString:@"api/v2/race.fetches.bymescroll?access_token=...&device_id=...&irace=...&flag=...&irank=..."];
//}

//+ (NSString*)rank_historyLink
//{
//    return [[self getrootURL] stringByAppendingString:@"api/achievements?access_token=...&device_id=...&user_id=..."];
//}

//+ (NSString*)rank_active_history
//{
//    return [[self getrootURL] stringByAppendingString:@"api/achivement.actived?access_token=...&device_id=...&user_id=..."];
//}

+ (RequestURL*)new_rank_active_history
{
    return [[RequestURL alloc] initWithURL:@"api/achivement.actived" Host:[self getrootURL] requestMethod:GET];
}

//+(NSString*)rank_closed_history
//{
//    return  [[self getrootURL] stringByAppendingString:@"api/achivement.closed?access_token=...&device_id=...&user_id=...&key=..."];
//}

+ (RequestURL*)new_rank_closed_history
{
    return [[RequestURL alloc] initWithURL:@"api/achivement.closed" Host:[self getrootURL] requestMethod:GET];
}


+ (RequestURL*)notification_pullLink
{
//    return [[self getChatRootURL] stringByAppendingString:@"ajax/pull.notitifcation"];
    return [[RequestURL alloc] initWithURL:@"ajax/pull.notitifcation" Host:[self getChatRootURL] requestMethod:GET];
}

+ (RequestURL*)setting_chatupdateLink
{
//    return [[self getrootURL] stringByAppendingString:@"account/profile.setting.chat"];
    return [[RequestURL alloc] initWithURL:@"account/profile.setting.chat" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL*)notification_fetchLink
{
//    return [[self getrootURL] stringByAppendingString:@"message/notifications.v2.fetch?access_token=...&device_id=...&notification_id=..."];
    return [[RequestURL alloc] initWithURL:@"message/notifications.v2.fetch" Host:[self getrootURL] requestMethod:GET];
}

//+ (NSString*)favourite_addLink
//{
//    return [[self getrootURL] stringByAppendingString:@"service/favourite.add"];
//}

+ (RequestURL*)auth_expiredLink
{
//    return [[self getrootURL] stringByAppendingString:@"oauth/auth.expired?access_token=...&device_id=..."];
    return [[RequestURL alloc] initWithURL:@"oauth/auth.expired" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)refresh_tokenLink
{
//    return [[self getrootURL] stringByAppendingString:@"oauth/auth.refresh_token"];
    return  [[RequestURL alloc] initWithURL:@"oauth/auth.refresh_token" Host:[self getrootURL] requestMethod:POST];
}

//+ (NSString*)user_searchLink
//{
//    return [[self getrootURL] stringByAppendingString:@"api/user.search?access_token=...&device_id=...&term=..."];
//}

//+ (NSString*)race_searchLink
//{
//    return [[self getrootURL] stringByAppendingString:@"api/v2/race.search?access_token=..&device_id=...&irace=...&gender=...&term=..."];
//}

//+ (NSString*)favourite_removeLink
//{
//    return [[self getrootURL] stringByAppendingString:@"service/favourite.remove"];
//}

//+ (NSString*)block_addLink
//{
//    return [[self getrootURL] stringByAppendingString:@"bloomer_apis/service/block.add"];
//}
//
//+ (NSString*)block_removeLink
//{
//    return [[self getrootURL] stringByAppendingString:@"bloomer_apis/service/block.remove"];
//}

+ (RequestURL*)block_fetchLink
{
    return [[RequestURL alloc] initWithURL:@"service/block.fetch" Host:[self getrootURL] requestMethod:GET];
}

//+ (NSString*)covers_loadLink
//{
//    return [[self getrootURL] stringByAppendingString:@"picture/covers.load?access_token=...&device_id=...&user_id=..."];
//}

+ (RequestURL*)covers_addLink
{
//    return [[self getrootURL] stringByAppendingString:@"picture/cover.add"];
    return [[RequestURL alloc] initWithURL:@"picture/cover.add" Host:[self getrootURL] requestMethod:POST];
}

//+ (NSString*)photo_cover_cropLink
//{
//    return [[self getPhotoRootURL] stringByAppendingString:@"picture/photo.cover.crop"];
//}

+ (RequestURL*)post_comment_deleteLink
{
//    return [[self getrootURL] stringByAppendingString:@"service/post.comment.delete?access_token=...&device_id=...&post_id=...&comment_id=..."];
    return [[RequestURL alloc] initWithURL:@"service/post.comment.delete" Host:[self getrootURL] requestMethod:DELETE];
}

+ (RequestURL*)post_deleteLink
{
//    return [[self getrootURL] stringByAppendingString:@"service/post.del?access_token=..&device_id=...&post_id=..."];
    return [[RequestURL alloc] initWithURL:@"service/post.del" Host:[self getrootURL] requestMethod:DELETE];
}

+ (RequestURL*)post_edit_captionLink
{
//    return [[self getrootURL] stringByAppendingString:@"social/post.edit.caption"];
    return [[RequestURL alloc] initWithURL:@"social/post.edit.caption" Host:[self getrootURL] requestMethod:POST];
}

//+ (NSString*)people_randomLink
//{
//    return [[self getrootURL] stringByAppendingString:@"api/people.randoms?access_token=...&device_id=...&gender=...&offset=..."];
//}

+ (RequestURL*)profile_change_genderLink
{
//    return [[self getrootURL] stringByAppendingString:@"account/profile.change-gender"];
    return [[RequestURL alloc] initWithURL:@"account/profile.change-gender" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL*)regions_fetchLink
{
    return [[RequestURL alloc] initWithURL:@"setting/regions.fetch" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)payment_packageLink
{
    return [[RequestURL alloc] initWithURL:@"payment/package.fetch" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)transaction_checkLink
{
    return [[RequestURL alloc] initWithURL:@"payment/transaction.check" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)joinrace_link {
    return [[RequestURL alloc] initWithURL:@"api/race.join" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)checkjoinedrace_link {
    return [[RequestURL alloc] initWithURL:@"api/race.joined" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_bannerAddLink {
    return [[RequestURL alloc] initWithURL:@"account/profile.banner.attached.v2" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_nameLink {
    return  [[RequestURL alloc] initWithURL:@"account/profile.update.displayname" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)post_captionLink {
    return [[RequestURL alloc] initWithURL:@"service/post.modify" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)access_codeLink {
    return [[RequestURL alloc] initWithURL:@"oauth/auth.access_code.verify" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_usernameLink {
    return [[RequestURL alloc] initWithURL:@"account/profile.update.username" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_statusLink {
    return [[RequestURL alloc] initWithURL:@"account/profile.update.aboutme" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_passwordLink {
    return [[RequestURL alloc] initWithURL:@"account/profile.change.pass" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)profile_set_PasswordLink
{
    return [[RequestURL alloc] initWithURL:@"account/profile.create.pass" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)leaverace_link {
    return [[RequestURL alloc] initWithURL:@"api/race.leave" Host:[self getrootURL] requestMethod:POST];
}

//+ (NSString*)raceinfo_link
//{
//    return [[self getrootURL] stringByAppendingString:@"api/race.info?access_token=...&device_id=...&irace=...&isNew=..."];
//}

//+ (NSString*)location_fetchLink
//{
//    return [[self getrootURL] stringByAppendingString:@"account/location.fetch?access_token=...&device_id=...&lat=...&lon=..."];
//}

+ (RequestURL *)location_loadLink {//http://dev.apis.bloomerapp.vn:8181/
    return [[RequestURL alloc] initWithURL:@"static/load.location.races" Host:[self getrootURL] requestMethod:GET];
}

+ (NSString*)join_race_confirmLink
{
    return [[self getrootURL] stringByAppendingString:@"api/join.race.confirm"];
}

+ (NSString*)termsOfUseLink
{
    return [[self getrootWebURL] stringByAppendingString:NSLocalizedString(@"term-of-uses/?tm=app", nil) ];
}

+ (NSString*)privacyPolicyLink
{
    return [[self getrootWebURL] stringByAppendingString:NSLocalizedString(@"privacy-policy/?tm=app", nil)];
}

+ (RequestURL*)shareFacebookLink
{
    return [[RequestURL alloc] initWithURL:@"service/sharepost" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)suggestedListLink
{
//    return [[self getrootURL] stringByAppendingString:@"service/suggest.list?access_token=...&device_id=..."];
    return [[RequestURL alloc] initWithURL:@"service/suggest.list" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)verifyInviteCodeLink
{
//    return [[self getrootURL] stringByAppendingString:@"account/usercode.check?access_token=...&device_id=...&invite_code=..."];
    return [[RequestURL alloc] initWithURL:@"account/usercode.check" Host:[self getrootURL] requestMethod:GET];
}

// MARK: - Tu Le: api getcurrent version
+ (RequestURL *)getVersionLink {
    return [[RequestURL alloc] initWithURL:@"oauth/auth.get_version" Host:[self getrootURL] requestMethod:GET];
}

+(RequestURL*)blockChat_addLink {
//    return [[self getrootURL] stringByAppendingString:@"follow/block.chat.add?access_token=...&device_id=...&block_id=..."];
    return [[RequestURL alloc] initWithURL:@"follow/block.chat.add" Host:[self getrootURL] requestMethod:GET];
}
+(RequestURL*)blockChat_removeLink {
//    return [[self getrootURL] stringByAppendingString:@"follow/block.chat.remove?access_token=...&device_id=...&block_id=..."];
    return [[RequestURL alloc] initWithURL:@"follow/block.chat.remove" Host:[self getrootURL] requestMethod:GET];
}
//+(NSString*)blockChat_loadLink {
//    return [[self getrootURL] stringByAppendingString:@"follow/blocker.chat.load?access_token=...&device_id=..."];
//}

+ (RequestURL*)user_race_posts_link
{
//    return [[self getrootURL] stringByAppendingString:@"api/gallery.get.v2?access_token=...&device_id=...&key=...&user_id=...&post_id=...&limit=..."];
    return [[RequestURL alloc] initWithURL:@"api/gallery.get.v2" Host:[self getrootURL] requestMethod:GET];
}

+(RequestURL*)getPopupMarketingLink {
    return [[RequestURL alloc] initWithURL:@"message/get.popup.maketing" Host:[self getrootURL] requestMethod:GET];
}

//+ (NSString*)popup_marketing_link
//{
//    return [[self getrootURL] stringByAppendingString:@"message/get.popup.maketing?access_token=...&device_id=..."];
//}

+(RequestURL*)getNotiMarketing {
    return [[RequestURL alloc] initWithURL:@"message/get.noti.maketing" Host:[self getrootURL] requestMethod:GET];
}

//Take a tour: Discovery
+ (RequestURL*)anonymous_load_location_racesLink {
//    return [[self getrootURL] stringByAppendingString:@"takeatour/load.location.races"];
    return [[RequestURL alloc] initWithURL:@"takeatour/load.location.races" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)anonymous_discovery_fetchesLink {
    return [[RequestURL alloc] initWithURL:@"takeatour/discovery.v2.load"
                                      Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)anonymous_discovery_searchLink {
    return [[RequestURL alloc] initWithURL:@"takeatour/search.discovery.full" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)getAnonymousRaceList {
    return [[RequestURL alloc] initWithURL:@"takeatour/racename.get.active" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)anonymous_feedLink
{
    return [[RequestURL alloc] initWithURL:@"takeatour/feeds" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)anonymous_feed_race_closedLink
{
    return [[RequestURL alloc] initWithURL:@"takeatour/feed.raceclosed.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)deletePopupNoti
{
    return [[RequestURL alloc] initWithURL:@"message/delete.noti" Host:[self getrootURL] requestMethod:GET];
}

// MARK: - Take a tour: RaceName Get

+ (RequestURL *)anonymous_race_name_fetchesLink {
    // takeatour/racename.get?key=...&gender=...
    return [[RequestURL alloc] initWithURL:@"takeatour/racename.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)anonymous_race_fetchesLink
{
    // takeatour/race.get?key=...&rank=...&is_refresh=...&gender=...&ckey=...
    
    return [[RequestURL alloc] initWithURL:@"takeatour/race.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)anonymous_races_surprise_fetchesLink {
    // takeatour/race.surprise.me?key=...&ckey=...&gender=...
    return [[RequestURL alloc] initWithURL:@"takeatour/race.surprise.me" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)anonymous_race_banner_fetchesLink {
//    return [[self getrootURL] stringByAppendingString:@"takeatour/race.banner.load?gender=...&key=...&ckey=...&is_refresh=..."];
    return [[RequestURL alloc] initWithURL:@"takeatour/race.banner.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)anonymous_profile_bannerLink {
//    return [[self getrootURL] stringByAppendingString:@"takeatour/profile.banner.load?user_id=..."];
    return [[RequestURL alloc] initWithURL:@"takeatour/profile.banner.load" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)anonymous_profile_New_fetchLink
{
//    return [[self getrootURL] stringByAppendingString:@"takeatour/profile.user.fetch.v2.5?user_id=..."];
    return [[RequestURL alloc] initWithURL:@"takeatour/profile.user.fetch.v2.5" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)anonymous_profile_galleryLink {
//    return [[self getrootURL] stringByAppendingString:@"takeatour/galleries.get?user_id=..."];
    return [[RequestURL alloc] initWithURL:@"takeatour/galleries.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)anonymous_profile_post_galleryLink { // get all posts of race on user ; postID for load more ; userID for load other profile
//    return [[self getrootURL] stringByAppendingString:@"takeatour/gallery.get?key=...&user_id=...&post_id=...&limit=..."];
    return [[RequestURL alloc] initWithURL:@"takeatour/gallery.get" Host:[self getrootURL] requestMethod:GET];
}

//+ (NSString*)anonymous_user_race_posts_link
//{
//    return [[self getrootURL] stringByAppendingString:@"takeatour/gallery.get.v2?key=...&user_id=...&post_id=...&limit=..."];
//}

+ (RequestURL*)getBannerMarketing {
    return [[RequestURL alloc] initWithURL:@"message/get.banner.maketing" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)getAnonymousBannerMarketing {
    return [[RequestURL alloc] initWithURL:@"takeatour/get.banner.maketing" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)getInviteCodeLink
{
    return [[RequestURL alloc] initWithURL:@"account/usercode.get" Host:[self getrootURL] requestMethod:GET];
}

// MARK: - GSB
+ (RequestURL*)getPopupMembership {
    return [[RequestURL alloc] initWithURL:@"message/get.popup.membership" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)getRewardMembership {
    return [[RequestURL alloc] initWithURL:@"api/reward.membership" Host:[self getrootURL] requestMethod:GET];
}

+ (NSString*)infoGSB {
    return [[self getrootWebURL] stringByAppendingString:NSLocalizedString(@"api/?action=f.gsb&lang=", nil) ];
}

+ (NSString*)benefitsGSB {
    return [[self getrootWebURL] stringByAppendingString:NSLocalizedString(@"api/?action=f.member&ratings=%@&lang=%@", nil) ];
}

+(RequestURL *)loadPhoto {
    return [[RequestURL alloc] initWithURL:@"static/loadphoto" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)getClubWinnersFetchLink {
    return [[RequestURL alloc] initWithURL:@"api/winners.get" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL *)CheckPhoneExistLink {
    return [[RequestURL alloc] initWithURL:@"oauth/auth.check_mobile" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)getClubWinnersSearchLink {
    return [[RequestURL alloc] initWithURL:@"api/winners.search" Host:[self getrootURL] requestMethod:GET];
}

+ (RequestURL*)ShareTopWinner {
    return [[RequestURL alloc] initWithURL:@"service/sharetopwinner" Host:[self getrootURL] requestMethod:GET];
}

#pragma mark FB
+ (RequestURL *)FBCheckExistLink {
    return [[RequestURL alloc] initWithURL:@"oauth/auth.facebookcheck" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)FBSendCodeLink {
    return [[RequestURL alloc] initWithURL:@"oauth/auth.register.fbsend_code" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)FBVerifyCodeLink {
    return [[RequestURL alloc] initWithURL:@"oauth/auth.fbregister.verify_code" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)FBRegisterLink {
    return [[RequestURL alloc] initWithURL:@"oauth/auth.registerbyfb" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)FBAuthenticationLink {
    return [[RequestURL alloc] initWithURL:@"oauth/auth.fbauthentication" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)AuthorizeByPassLink{
    return [[RequestURL alloc] initWithURL:@"oauth/auth.authenticationbypass" Host:[self getrootURL] requestMethod:POST];
}

+ (RequestURL *)AuthorizeByCodeLink{
    return [[RequestURL alloc] initWithURL:@"oauth/auth.authorizeverifybycode" Host:[self getrootURL] requestMethod:POST];
}

+(RequestURL *)getCountriesLink {
    return [[RequestURL alloc] initWithURL:@"static/countries.active" Host:[self getrootURL] requestMethod:GET];
}

//MARK:- WEB_SOCKET
+ (NSString *)hostSocket{
    
    NSString* result;
    switch ([APIDefine getEnvironment]) {
        case DEVELOPMENT:
            result=@"ws://dev.apis.bloomerapp.vn:8083/chat"; //DEV
            break;
        case STAGING:
            result=@"wss://staging-messages.bloomerapp.com/chat"; //STAGING
            break;
        default:
            result=@"wss://messages.bloomerapp.com/chat"; //AMAZON
            break;
    }
    return result;
    
}

+ (NSString *)authenticateEvent{
    return @"authen";
}

+ (NSString *) messageHistoryRequest{
    return @"read_request";
}

+ (NSString *)messageHistoryResponse{
    return @"read_response";
}

+ (NSString *)sendMessageEvent{
    return @"send_request";
}

+ (NSString *)sendMessageResponse{
    return @"send_response";
}

+ (NSString *)receiveMessageEvent{
    return @"receive";
}

+ (NSString *)blockChatRequest{
    return @"block_chat_request";
}

+ (NSString *)blockChatResponse{
    return @"block_chat_response";
}

+ (NSString *)unBlockChatRequest{
    return @"unblock_chat_request";
}

+ (NSString *)unBlockChatResponse{
    return @"unblock_chat_response";
}

+ (NSString *) errorEvent{
    return @"error";
}

+ (NSString *) authenEvent {
    return @"authen";
}

@end
