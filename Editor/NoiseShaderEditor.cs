using System.Linq;
using UnityEngine;
using UnityEditor;

public class NoiseShaderEditor : ShaderGUI
{
    //言語切り替え用の各項目名
    private string mainTex_, emissionLevel_, alphaBlend_, uvScaling_, timeScale_,
            slippingPosOffset_, slippingFrequency_, slippingLevel_, slippingWidth_, noiseParam1_, noiseIntensity_,
            verticalSlipping_,
            noiseFreq_, noiseDetail_, noiseSpeed_, noiseThreshold_, noiseWidth_,
            stretchIntensity_, stretchLevel_, stretchThreshold_, noiseParam4_,
            rgbSeparationWidth_, rgbSeparationThreshold_, noiseParam5_,
            mosicLevel_, mosicThreshold_,
            waveSpeed_, lineWidth_, lineIntensity_,
            simpleNoiseLevel_, simpleNoiseScale_, noiseParam7_,
            pixelNum_, pixelSize_, pixelWidth_,
            TexSettingisOpen_, UVSliceisOpen_, UVNoiseisOpen_, UVStretchisOpen_, RGBSeparationisOpen_,
            MosicisOpen_, WaveisOpen_, SimpleNoiseisOpen_, PixelisOpen_;

    private int language;//0:英語、1:日本語

    //折り畳み用
    private bool _TexSettingisOpen = true;
    private void DetermineSubtitle(int lang)
    {
        mainTex_ = lang == 1 ? "テクスチャ画像" : "Texture Image";
        emissionLevel_ = lang == 1 ? "発光の強度" : "Emission Level";
        uvScaling_ = lang == 1 ? "UVの拡縮" : "UV Scaling";
        alphaBlend_ = lang == 1 ? "アルファ有効" : "Alpha";
        timeScale_ = lang == 1 ? "アニメーションの速度" : "Animation Speed";
        slippingPosOffset_ = lang == 1 ? "位置のオフセット" : "Position Offset";
        slippingFrequency_ = lang == 1 ? "頻度" : "Frequency";
        slippingLevel_ = lang == 1 ? "度合い" : "Intensity";
        slippingWidth_ = lang == 1 ? "幅" : "Width";
        noiseParam1_ = lang == 1 ? "ノイズ用パラメータ" : "Noise Parameter";
        noiseIntensity_ = lang == 1 ? "ノイズの強さ" : "Noise Intensity";
        verticalSlipping_ = lang == 1 ? "縦方向のずれ" : "Vertical Slipping";
        noiseFreq_ = lang == 1 ? "頻度" : "Frequency";
        noiseDetail_ = lang == 1 ? "細部" : "Detail";
        noiseSpeed_ = lang == 1 ? "速さ" : "Speed";
        noiseThreshold_ = lang == 1 ? "閾値" : "Threshold";
        noiseWidth_ = lang == 1 ? "幅" : "Width";
        stretchIntensity_ = lang == 1 ? "伸びの強さ" : "Stretch Intensity";
        stretchLevel_ = lang == 1 ? "段階" : "Stretch Level";
        stretchThreshold_ = lang == 1 ? "閾値" : "Threshold";
        noiseParam4_ = lang == 1 ? "ノイズ用パラメータ" : "Noise Parameter";
        rgbSeparationWidth_ = lang == 1 ? "ずれ幅" : "Separation Width";
        rgbSeparationThreshold_ = lang == 1 ? "閾値" : "Threshold";
        noiseParam5_ = lang == 1 ? "ノイズ用パラメータ" : "Noise Parameter";
        mosicLevel_ = lang == 1 ? "モザイクの度合い" : "Mosic Level";
        mosicThreshold_ = lang == 1 ? "頻度" : "Frequency";
        waveSpeed_ = lang == 1 ? "波の速度" : "Wave Speed";
        lineWidth_ = lang == 1 ? "線幅" : "Line Width";
        lineIntensity_ = lang == 1 ? "線の濃さ" : "Line Intensity";
        simpleNoiseLevel_ = lang == 1 ? "濃さ" : "Noise Depth";
        simpleNoiseScale_ = lang == 1 ? "細かさ" : "Noise Scale";
        noiseParam7_ = lang == 1 ? "ノイズ用パラメータ" : "Noise Paraneter";
        pixelNum_ = lang == 1 ? "ピクセルの数" : "Number of Pixel";
        pixelSize_ = lang == 1 ? "サイズ" : "Pixel Size";
        pixelWidth_ = lang == 1 ? "幅調整" : "Pixel Width";
        TexSettingisOpen_ = lang == 1 ? "テクスチャ画像の設定" : "Texture Setting";
        UVSliceisOpen_ = lang == 1 ? "UVずらし" : "UV Slice";
        UVNoiseisOpen_ = lang == 1 ? "UVノイズ" : "UVNoise";
        UVStretchisOpen_ = lang == 1 ? "UV伸ばし" : "UV Stretch";
        RGBSeparationisOpen_ = lang == 1 ? "RGB分離" : "RGB Separation";
        MosicisOpen_ = lang == 1 ? "モザイク" : "Mosic";
        WaveisOpen_ = lang == 1 ? "波線" : "Wave";
        SimpleNoiseisOpen_ = lang == 1 ? "ホワイトノイズ" : "White Noise";
        PixelisOpen_ = lang == 1 ? "ピクセル風" : "Display Pixels";
    }
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        //タイトル用の書体
        GUIStyle leftbold = new GUIStyle()
        {
            alignment = TextAnchor.MiddleLeft,
            fontStyle = FontStyle.Bold,
        };

        language = GUILayout.Toolbar(language, new string[] { "English", "日本語" });
        DetermineSubtitle(language);
        bool TexSettingisOpen = EditorGUILayout.Foldout(_TexSettingisOpen, TexSettingisOpen_);
        if (_TexSettingisOpen != TexSettingisOpen) _TexSettingisOpen = TexSettingisOpen;
        if (TexSettingisOpen)
        {
            EditorStyles.label.fontStyle = FontStyle.Normal;
            var _MainTex = properties.First(x => x.name == "_MainTex");
            materialEditor.ShaderProperty(_MainTex, mainTex_);
            var _EmissionLevel = properties.First(x => x.name == "_EmissionLevel");
            materialEditor.ShaderProperty(_EmissionLevel, emissionLevel_);
            var _AlphaBlend = properties.First(x => x.name == "_AlphaBlend");
            materialEditor.ShaderProperty(_AlphaBlend, alphaBlend_);
            var _UVScalingX = properties.First(x => x.name == "_UVScalingX");
            materialEditor.ShaderProperty(_UVScalingX, uvScaling_ + "(x)");
            var _UVScalingY = properties.First(x => x.name == "_UVScalingY");
            materialEditor.ShaderProperty(_UVScalingY, uvScaling_ + "(y)");
        }

        EditorStyles.label.fontStyle = FontStyle.Normal;

        var _TimeScale = properties.First(x => x.name == "_TimeScale");
        materialEditor.ShaderProperty(_TimeScale, timeScale_);

        var _VerticalSlipping = properties.First(x => x.name == "_VerticalSlipping");
        materialEditor.ShaderProperty(_VerticalSlipping, verticalSlipping_);

        GUILayout.Space(10);

        using (new EditorGUILayout.VerticalScope("box"))
        {
            EditorStyles.label.fontStyle = FontStyle.Bold;
            var _UVHorizontalSlipOn = properties.First(x => x.name == "_UVHorizontalSlipOn");
            materialEditor.ShaderProperty(_UVHorizontalSlipOn, UVSliceisOpen_);
            if (properties[6].floatValue == 1)
            {
                EditorGUI.indentLevel++;
                EditorStyles.label.fontStyle = FontStyle.Normal;
                var _SlippingPosOffset = properties.First(x => x.name == "_SlippingPosOffset");
                materialEditor.ShaderProperty(_SlippingPosOffset, slippingPosOffset_);
                var _SlippingFrequency = properties.First(x => x.name == "_SlippingFrequency");
                materialEditor.ShaderProperty(_SlippingFrequency, slippingFrequency_);
                var _SlippingLevel = properties.First(x => x.name == "_SlippingLevel");
                materialEditor.ShaderProperty(_SlippingLevel, slippingLevel_);
                var _SlippingWidth = properties.First(x => x.name == "_SlippingWidth");
                materialEditor.ShaderProperty(_SlippingWidth, slippingWidth_);
                var _NoiseParam1 = properties.First(x => x.name == "_NoiseParam1");
                materialEditor.ShaderProperty(_NoiseParam1, noiseParam1_);
                var _NoiseIntensity = properties.First(x => x.name == "_NoiseIntensity");
                materialEditor.ShaderProperty(_NoiseIntensity, noiseIntensity_);
                EditorGUI.indentLevel--;
            }
        }

        using (new EditorGUILayout.VerticalScope("box"))
        {
            EditorStyles.label.fontStyle = FontStyle.Bold;
            var _UVNoiseOn = properties.First(x => x.name == "_UVNoiseOn");
            materialEditor.ShaderProperty(_UVNoiseOn, UVNoiseisOpen_);
            if (properties[14].floatValue == 1)
            {
                EditorGUI.indentLevel++;
                EditorStyles.label.fontStyle = FontStyle.Normal;
                var _NoiseFrequency = properties.First(x => x.name == "_NoiseFrequency");
                materialEditor.ShaderProperty(_NoiseFrequency, noiseFreq_);
                var _NoiseDetail = properties.First(x => x.name == "_NoiseDetail");
                materialEditor.ShaderProperty(_NoiseDetail, noiseDetail_);
                var _NoiseSpeed = properties.First(x => x.name == "_NoiseSpeed");
                materialEditor.ShaderProperty(_NoiseSpeed, noiseSpeed_);
                var _NoiseThreshold = properties.First(x => x.name == "_NoiseThreshold");
                materialEditor.ShaderProperty(_NoiseThreshold, noiseThreshold_);
                var _NoiseWidth = properties.First(x => x.name == "_NoiseWidth");
                materialEditor.ShaderProperty(_NoiseWidth, noiseWidth_);
                EditorGUI.indentLevel--;
            }
        }
        using (new EditorGUILayout.VerticalScope("box"))
        {
            EditorStyles.label.fontStyle = FontStyle.Bold;
            var _StretchOn = properties.First(x => x.name == "_StretchOn");
            materialEditor.ShaderProperty(_StretchOn, UVStretchisOpen_);
            if (properties[20].floatValue == 1)
            {
                EditorGUI.indentLevel++;
                EditorStyles.label.fontStyle = FontStyle.Normal;
                var _StretchIntensity = properties.First(x => x.name == "_StretchIntensity");
                materialEditor.ShaderProperty(_StretchIntensity, stretchIntensity_);
                var _StretchLevel = properties.First(x => x.name == "_StretchLevel");
                materialEditor.ShaderProperty(_StretchLevel, stretchLevel_);
                var _StretchThreshold = properties.First(x => x.name == "_StretchThreshold");
                materialEditor.ShaderProperty(_StretchThreshold, stretchThreshold_);
                var _NoiseParam4 = properties.First(x => x.name == "_NoiseParam4");
                materialEditor.ShaderProperty(_NoiseParam4, noiseParam4_);
                EditorGUI.indentLevel--;
            }
        }
        using (new EditorGUILayout.VerticalScope("box"))
        {
            EditorStyles.label.fontStyle = FontStyle.Bold;
            var _SeparationOn = properties.First(x => x.name == "_SeparationOn");
            materialEditor.ShaderProperty(_SeparationOn, RGBSeparationisOpen_);
            if (properties[25].floatValue == 1)
            {
                EditorGUI.indentLevel++;
                EditorStyles.label.fontStyle = FontStyle.Normal;
                var _RGBSeparationWidth = properties.First(x => x.name == "_RGBSeparationWidth");
                materialEditor.ShaderProperty(_RGBSeparationWidth, rgbSeparationWidth_);
                var _RGBSeparationThreshold = properties.First(x => x.name == "_RGBSeparationThreshold");
                materialEditor.ShaderProperty(_RGBSeparationThreshold, rgbSeparationThreshold_);
                var _NoiseParam5 = properties.First(x => x.name == "_NoiseParam5");
                materialEditor.ShaderProperty(_NoiseParam5, noiseParam5_);
                EditorGUI.indentLevel--;
            }
        }
        using (new EditorGUILayout.VerticalScope("box"))
        {
            EditorStyles.label.fontStyle = FontStyle.Bold;
            var _MosicOn = properties.First(x => x.name == "_MosicOn");
            materialEditor.ShaderProperty(_MosicOn, MosicisOpen_);
            if (properties[29].floatValue == 1)
            {
                EditorGUI.indentLevel++;
                EditorStyles.label.fontStyle = FontStyle.Normal;
                var _MosicLevelX = properties.First(x => x.name == "_MosicLevelX");
                materialEditor.ShaderProperty(_MosicLevelX, mosicLevel_ + "(x)");
                var _MosicLevelY = properties.First(x => x.name == "_MosicLevelY");
                materialEditor.ShaderProperty(_MosicLevelY, mosicLevel_ + "(y)");
                var _MosicThreshold = properties.First(x => x.name == "_MosicThreshold");
                materialEditor.ShaderProperty(_MosicThreshold, mosicThreshold_);
                EditorGUI.indentLevel--;
            }
        }
        using (new EditorGUILayout.VerticalScope("box"))
        {
            EditorStyles.label.fontStyle = FontStyle.Bold;
            var _WaveOn = properties.First(x => x.name == "_WaveOn");
            materialEditor.ShaderProperty(_WaveOn, WaveisOpen_);
            if (properties[33].floatValue == 1)
            {
                EditorGUI.indentLevel++;
                EditorStyles.label.fontStyle = FontStyle.Normal;
                var _WaveSpeed = properties.First(x => x.name == "_WaveSpeed");
                materialEditor.ShaderProperty(_WaveSpeed, waveSpeed_);
                var _LineWidth = properties.First(x => x.name == "_LineWidth");
                materialEditor.ShaderProperty(_LineWidth, lineWidth_);
                var _LineIntensity = properties.First(x => x.name == "_LineIntensity");
                materialEditor.ShaderProperty(_LineIntensity, lineIntensity_);
                EditorGUI.indentLevel--;
            }
        }
        using (new EditorGUILayout.VerticalScope("box"))
        {
            EditorStyles.label.fontStyle = FontStyle.Bold;
            var _SimpleNoiseOn = properties.First(x => x.name == "_SimpleNoiseOn");
            materialEditor.ShaderProperty(_SimpleNoiseOn, SimpleNoiseisOpen_);
            if (properties[37].floatValue == 1)
            {
                EditorGUI.indentLevel++;
                EditorStyles.label.fontStyle = FontStyle.Normal;
                var _SimpleNoiseLevel = properties.First(x => x.name == "_SimpleNoiseLevel");
                materialEditor.ShaderProperty(_SimpleNoiseLevel, simpleNoiseLevel_);
                var _SimpleNoiseScale = properties.First(x => x.name == "_SimpleNoiseScale");
                materialEditor.ShaderProperty(_SimpleNoiseScale, simpleNoiseScale_);
                var _NoiseParam7 = properties.First(x => x.name == "_NoiseParam7");
                materialEditor.ShaderProperty(_NoiseParam7, noiseParam7_);
                EditorGUI.indentLevel--;
            }
        }
        using (new EditorGUILayout.VerticalScope("box"))
        {
            EditorStyles.label.fontStyle = FontStyle.Bold;
            var _PixelizeOn = properties.First(x => x.name == "_PixelizeOn");
            materialEditor.ShaderProperty(_PixelizeOn, PixelisOpen_);
            if (properties[41].floatValue == 1)
            {
                EditorGUI.indentLevel++;
                EditorStyles.label.fontStyle = FontStyle.Normal;
                var _PixelNum = properties.First(x => x.name == "_PixelNum");
                materialEditor.ShaderProperty(_PixelNum, pixelNum_);
                var _PixelSize = properties.First(x => x.name == "_PixelSize");
                materialEditor.ShaderProperty(_PixelSize, pixelSize_);
                var _PixelWidth = properties.First(x => x.name == "_PixelWidth");
                materialEditor.ShaderProperty(_PixelWidth, pixelWidth_);
                EditorGUI.indentLevel--;
            }
        }
    }
}