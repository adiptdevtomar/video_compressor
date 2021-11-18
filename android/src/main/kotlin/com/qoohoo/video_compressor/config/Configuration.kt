package com.qoohoo.video_compressor

import com.abedelazizshe.lightcompressorlibrary.VideoQuality

data class Configuration(
        //var quality: VideoQuality = VideoQuality.MEDIUM,
        var frameRate: Int? = null,
        //var isMinBitrateCheckEnabled: Boolean = true,
        var videoBitrate: Int? = null,
)
