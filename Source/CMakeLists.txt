
if(${KMETER_SURROUND})
    set(TARGET_NAME K-Meter_surround)
else()
    set(TARGET_NAME K-Meter)
endif()

message(STATUS "targetting plugin formats: ${plugin_formats}")

juce_add_plugin(${TARGET_NAME}
    VERSION 2.8.2
    COMPANY_NAME "MartinZuther"
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
    target_compile_definitions(${TARGET_NAME} PUBLIC KMETER_SURROUND=1)
else()
    message(STATUS "building plugin in stereo mode")
    target_compile_definitions(${TARGET_NAME} PUBLIC KMETER_STEREO=1)
endif()


juce_generate_juce_header(${TARGET_NAME})


target_sources(${TARGET_NAME}
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


target_compile_definitions(${TARGET_NAME}
    PUBLIC
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0
        JUCE_MODAL_LOOPS_PERMITTED=1

        FRUT_DSP_USE_FFTW=1
)

target_compile_options(${TARGET_NAME}
    PUBLIC
        -O3
        -fPIC
)


target_include_directories(${TARGET_NAME} 
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/frut
)


target_link_libraries(${TARGET_NAME}
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
        juce::juce_video
        juce::juce_audio_formats
        juce::juce_core
        juce::juce_audio_plugin_client
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags
)


target_link_options(${TARGET_NAME}
    PUBLIC
        -flto=auto
)

foreach(pformat ${plugin_formats})
    set(target ${TARGET_NAME}_${pformat})

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
            $<TARGET_FILE_DIR:${target}>/kmeter/skins/
    )

    # copy docs
    set(doc_files "kmeter.pdf" "CC-BY-SA-4.0" "CONTRIBUTORS" "HISTORY" "LICENSE")

    foreach(fname ${doc_files})
        add_custom_command(
            TARGET ${target}
            PRE_BUILD
            COMMENT "copying ${fname} for ${target}"
            COMMAND mkdir -p $<TARGET_FILE_DIR:${target}>/kmeter/doc/
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                ${PROJECT_SOURCE_DIR}/doc/${fname}
                $<TARGET_FILE_DIR:${target}>/kmeter/doc/
        )
    endforeach()
    
    install(DIRECTORY $<TARGET_FILE_DIR:${TARGET_NAME}>/${pformat} DESTINATION .)
endforeach()

