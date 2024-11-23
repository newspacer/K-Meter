
set(plugin_formats VST3 LV2 Standalone)


juce_add_plugin(K-Meter
    VERSION 2.8.2
    COMPANY_NAME "Martin Zuther"
    LV2URI "https://github.com/mzuther/K-Meter"
    IS_SYNTH FALSE
    NEEDS_MIDI_INPUT FALSE
    NEEDS_MIDI_OUTPUT FALSE
    IS_MIDI_EFFECT FALSE
    EDITOR_WANTS_KEYBOARD_FOCUS FALSE
    COPY_PLUGIN_AFTER_BUILD FALSE
    PLUGIN_MANUFACTURER_CODE MZut
    PLUGIN_CODE kmet
    FORMATS ${plugin_formats}
)

if(${KMETER_SURROUND})
    message(STATUS "building plugin in surround mode")
    target_compile_definitions(K-Meter PUBLIC KMETER_SURROUND=1)
else()
    message(STATUS "building plugin in stereo mode")
    target_compile_definitions(K-Meter PUBLIC KMETER_STEREO=1)
endif()


juce_generate_juce_header(K-Meter)


target_sources(K-Meter
    PRIVATE
        frut/amalgamated/include_frut_audio.cpp
        frut/amalgamated/include_frut_dsp.cpp
        frut/amalgamated/include_frut_math.cpp
        frut/amalgamated/include_frut_parameters.cpp
        frut/amalgamated/include_frut_skin.cpp
        frut/amalgamated/include_frut_widgets.cpp

        audio_file_player.cpp
        average_level_filtered.cpp
        kmeter.cpp
        meter_ballistics.cpp
        meter_bar.cpp
        overflow_meter.cpp
        peak_label.cpp
        plugin_editor.cpp
        plugin_parameters.cpp
        plugin_processor.cpp
        skin.cpp
        window_validation_content.cpp
)


target_compile_definitions(K-Meter
    PUBLIC
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0

        FRUT_DSP_USE_FFTW=1
)

target_compile_options(K-Meter
    PUBLIC
        -O3
        -fPIC
)


target_include_directories(K-Meter 
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/frut
)


target_link_libraries(K-Meter
    PRIVATE
        fftw3f

        juce::juce_audio_basics
        juce::juce_audio_devices
        juce::juce_audio_processors
        juce::juce_audio_utils
        juce::juce_cryptography
        juce::juce_data_structures
        juce::juce_events
        juce::juce_graphics
        juce::juce_gui_basics
        juce::juce_gui_extra
        juce::juce_opengl
        juce::juce_box2d
        #juce::juce_browser_plugin_client
        juce::juce_video
        juce::juce_audio_formats
        juce::juce_core
        juce::juce_audio_plugin_client
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags
)


foreach(pformat ${plugin_formats})
    set(target K-Meter_${pformat})

    # copy skin dir
    add_custom_command(
        TARGET ${target}
        PRE_BUILD
        COMMENT "copying Default skin directory for ${target}"
        COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different
            ${PROJECT_SOURCE_DIR}/skins/Default
            $<TARGET_FILE_DIR:${target}>/kmeter/skins/Default
    )

    # copy skin file
    add_custom_command(
        TARGET ${target}
        PRE_BUILD
        COMMENT "copying Default skin for ${target}"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${PROJECT_SOURCE_DIR}/skins/Default.skin
            $<TARGET_FILE_DIR:${target}>/kmeter/skins
    )

    # copy docs
    add_custom_command(
        TARGET ${target}
        PRE_BUILD
        COMMENT "copying pdf doc for ${target}"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${PROJECT_SOURCE_DIR}/doc/kmeter.pdf
            $<TARGET_FILE_DIR:${target}>/kmeter
    )
    add_custom_command(
        TARGET ${target}
        PRE_BUILD
        COMMENT "copying licence docs directory for ${target}"
        COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different
            ${PROJECT_SOURCE_DIR}/bin/standalone/kmeter/doc/
            $<TARGET_FILE_DIR:${target}>/kmeter/doc
    )
endforeach()

install(TARGETS K-Meter_VST3 LIBRARY DESTINATION vst3 COMPONENT VST3)
install(TARGETS K-Meter_LV2 LIBRARY DESTINATION lv2 COMPONENT LV2)
install(TARGETS K-Meter_Standalone RUNTIME DESTINATION standalone COMPONENT STANDALONE)

set(CPACK_COMPONENTS_ALL VST3 LV2 STANDALONE)

