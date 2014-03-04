// supporting macros for code to allow building with and without arc


#ifndef __has_feature
    // not LLVM Compiler
    #define __has_feature(x) 0
#endif

#ifndef CF_CONSUMED
    #if __has_feature(attribute_cf_consumed)
        #define CF_CONSUMED __attribute__((cf_consumed))
    #else
        #define CF_CONSUMED
    #endif
#endif


// ----- ARC Enabled -----
#if __has_feature(objc_arc) && !defined(ARC_IS_ENABLED)

    #define ARC_IS_ENABLED 1

    //define retain count macro wrappers
    #define arc_retain(x)       (x)
    #define arc_release(x)
    #define arc_release_nil(x)  (x = nil)
    #define arc_autorelease(x)  (x)
    #define arc_super_dealloc()


#endif


// ----- ARC Disabled -----
#if !__has_feature(objc_arc) && !defined(ARC_IS_ENABLED)

    #define ARC_IS_ENABLED 0

    //define retain count macro wrappers
    #define arc_retain(x)       ([x retain])
    #define arc_release(x)      ([x release])
    #define arc_release_nil(x)   [x release]; x = nil;
    #define arc_autorelease(x)  ([x autorelease])
    #define arc_super_dealloc() ([super dealloc])

    //add arc keywords if not already defined
    #ifndef __bridge
        #define __bridge
    #endif

    #ifndef __bridge_retained
        #define __bridge_retained
    #endif

    #ifndef __bridge_transfer
        #define __bridge_transfer
    #endif

    #ifndef __autoreleasing
        #define __autoreleasing
    #endif

    #ifndef __strong
        #define __strong
    #endif

    #ifndef __weak
        #define __weak
    #endif

    #ifndef __unsafe_unretained
        #define __unsafe_unretained
    #endif

    //add CF bridging methods (we inline these ourselves because they are not included in older sdks)
    NS_INLINE CF_RETURNS_RETAINED CFTypeRef ARCBridgingRetain(id X) {
        return X ? CFRetain((CFTypeRef)X) : NULL;
    }

    NS_INLINE id ARCBridgingRelease(CFTypeRef CF_CONSUMED X) {
        return [(id)CFMakeCollectable(X) autorelease];
    }

#endif


//if clarity helper
#define ARC_IS_NOT_ENABLED (!(ARC_IS_ENABLED))


