using UnityEngine;

public class NoiseEffect : CustomImageEffect
{
    #region Fields

    [SerializeField] float _UVScalingX, _UVScalingY;
    

    [SerializeField] [Range(0, 100)] float _TimeScale;
    [SerializeField] int _UVHorizontalSlipOn;
    [SerializeField] float _SlippingPosOffset;
    [SerializeField] int _SlippingFrequency;
    [SerializeField] [Range(0, 2)] float _SlippingLevel;
    [SerializeField] float _SlippingWidth, _NoiseParam1, _NoiseIntensity;
    

    [SerializeField] [Range(-1, 1)] float _VerticalSlipping;

    [SerializeField] int _UVNoiseOn;
    [SerializeField] float _NoiseFrequency, _NoiseDetail, _NoiseSpeed;
    [SerializeField] [Range(0, 1)] float _NoiseThreshold;
    [SerializeField] [Range(0, 25)] float _NoiseWidth;

    [SerializeField] int _StretchOn, _StretchIntensity, _StretchLevel;
    [SerializeField] [Range(0, 1)] float _StretchThreshold;
    [SerializeField] int _NoiseParam4;

    [SerializeField] int _SeparationOn;
    [SerializeField] [Range(0, 1)] float _RGBSeparationWidth;
    [SerializeField] [Range(0, 1)] float _RGBSeparationThreshold;
    [SerializeField] int _NoiseParam5;

    [SerializeField] int _MosicOn;
    [SerializeField] [Range(0, 1000)] float _MosicLevelX;
    [SerializeField] [Range(0, 1000)] float _MosicLevelY;
    [SerializeField] [Range(0, 1)] float _MosicThreshold;

    [SerializeField] int _WaveOn;
    [SerializeField] float _WaveSpeed, _LineWidth;
    [SerializeField] [Range(0, 1)] float _LineIntensity;

    [SerializeField] int _SimpleNoiseOn;
    [SerializeField] [Range(0, 2.5f)] float _SimpleNoiseLevel;
    [SerializeField] [Range(250, 50000)] float _SimpleNoiseScale;
    [SerializeField] int _NoiseParam7;

    [SerializeField] int _PixelizeOn;
    [SerializeField] [Range(5, 1000)] float _PixelNum;
    [SerializeField] [Range(0, 1)] float _PixelSize;
    [SerializeField] [Range(0, 1)] float _PixelWidth;

    public float UVScalingX { get { return _UVScalingX; } set { _UVScalingX = value; } }
    public float UVScalingY { get { return _UVScalingY; } set { _UVScalingY = value; } }
    public float TimeScale { get { return _TimeScale; } set { _TimeScale = value; } }
    public int UVHorizontalSlipOn { get { return _UVHorizontalSlipOn; } set { _UVHorizontalSlipOn = value; } }
    public float SlippingPosOffset { get { return _SlippingPosOffset; } set { _SlippingPosOffset = value; } }
    public int SlippingFrequency { get { return _SlippingFrequency; } set { _SlippingFrequency = value; } }
    public float SlippingLevel { get { return _SlippingLevel; } set { _SlippingLevel = value; } }
    public float SlippingWidth { get { return _SlippingWidth; } set { _SlippingWidth = value; } }
    public float NoiseParam1 { get { return _NoiseParam1; } set { _NoiseParam1 = value; } }
    public float NoiseIntensity { get { return _NoiseIntensity; } set { _NoiseIntensity = value; } }
    public float VerticalSlipping { get { return _VerticalSlipping; } set { _VerticalSlipping = value; } }
    public int UVNoiseOn { get { return _UVNoiseOn; } set { _UVNoiseOn = value; } }
    public float NoiseFrequency { get { return _NoiseFrequency; } set { _NoiseFrequency = value; } }
    public float NoiseDetail { get { return _NoiseDetail; } set { _NoiseDetail = value; } }
    public float NoiseSpeed { get { return _NoiseSpeed; } set { _NoiseSpeed = value; } }
    public float NoiseThreshold { get { return _NoiseThreshold; } set { _NoiseThreshold = value; } }
    public float NoiseWidth { get { return _NoiseWidth; } set { _NoiseWidth = value; } }
    public int StretchOn { get { return _StretchOn; } set { _StretchOn = value; } }
    public int StretchIntensity { get { return _StretchIntensity; } set { _StretchIntensity = value; } }
    public int StretchLevel { get { return _StretchLevel; } set { _StretchLevel = value; } }
    public float StretchThreshold { get { return _StretchThreshold; } set { _StretchThreshold = value; } }
    public int NoiseParam4 { get { return _NoiseParam4; } set { _NoiseParam4 = value; } }
    public int SeparationOn { get { return _SeparationOn; } set { _SeparationOn = value; } }
    public float RGBSeparationWidth { get { return _RGBSeparationWidth; } set { _RGBSeparationWidth = value; } }
    public float RGBSeparationThreshold { get { return _RGBSeparationThreshold; } set { _RGBSeparationThreshold = value; } }
    public int NoiseParam5 { get { return _NoiseParam5; } set { _NoiseParam5 = value; } }
    public int MosicOn { get { return _MosicOn; } set { _MosicOn = value; } }
    public float MosicLevelX { get { return _MosicLevelX; } set { _MosicLevelX = value; } }
    public float MosicLevelY { get { return _MosicLevelY; } set { _MosicLevelY = value; } }
    public float MosicThreshold { get { return _MosicThreshold; } set { _MosicThreshold = value; } }
    public int WaveOn { get { return _WaveOn; } set { _WaveOn = value; } }
    public float WaveSpeed { get { return _WaveSpeed; } set { _WaveSpeed = value; } }
    public float LineWidth { get { return _LineWidth; } set { _LineWidth = value; } }
    public float LineIntensity { get { return _LineIntensity; } set { _LineIntensity = value; } }
    public int SimpleNoiseOn { get { return _SimpleNoiseOn; } set { _SimpleNoiseOn = value; } }
    public float SimpleNoiseLevel { get { return _SimpleNoiseLevel; } set { _SimpleNoiseLevel = value; } }
    public float SimpleNoiseScale { get { return _SimpleNoiseScale; } set { _SimpleNoiseScale = value; } }
    public int NoiseParam7 { get { return _NoiseParam7; } set { _NoiseParam7 = value; } }
    public int PixelizeOn { get { return _PixelizeOn; } set { _PixelizeOn = value; } }
    public float PixelNum { get { return _PixelNum; } set { _PixelNum = value; } }
    public float PixelSize { get { return _PixelSize; } set { _PixelSize = value; } }
    public float PixelWidth { get { return _PixelWidth; } set { _PixelWidth = value; } }

    #endregion

    #region Properties

    public override string ShaderName
    {
        get { return "Custom/NoiseShaderPostEffect"; }
    }

    #endregion

    #region Methods

    protected override void UpdateMaterial()
    {
        Material.SetFloat("_UVScalingX", _UVScalingX);
        //[NoScaleOffset] _MainTex("Main Texture", 2D) = "white" { }

        Material.SetFloat("_UVScalingY", _UVScalingY);

        Material.SetFloat("_TimeScale", _TimeScale);

        Material.SetInt("_UVHorizontalSlipOn", _UVHorizontalSlipOn);
        Material.SetFloat("_SlippingPosOffset", _SlippingPosOffset);
        Material.SetFloat("_SlippingFrequency", _SlippingFrequency);
        Material.SetFloat("_SlippingLevel", _SlippingLevel);
        Material.SetFloat("_SlippingWidth", _SlippingWidth);
        Material.SetFloat("_NoiseParam1", _NoiseParam1);
        Material.SetFloat("_NoiseIntensity", _NoiseIntensity);

        Material.SetFloat("_VerticalSlipping", _VerticalSlipping);

        Material.SetInt("_UVNoiseOn", _UVNoiseOn);
        Material.SetFloat("_NoiseFrequency", _NoiseFrequency);
        Material.SetFloat("_NoiseDetail", _NoiseDetail);
        Material.SetFloat("_NoiseSpeed", _NoiseSpeed);
        Material.SetFloat("_NoiseThreshold", _NoiseThreshold);
        Material.SetFloat("_NoiseWidth", _NoiseWidth);

        Material.SetInt("_StretchOn", _StretchOn);
        Material.SetFloat("_StretchIntensity", _StretchIntensity);
        Material.SetFloat("_StretchLevel", _StretchLevel);
        Material.SetFloat("_StretchThreshold", _StretchThreshold);
        Material.SetFloat("_NoiseParam4", _NoiseParam4);

        Material.SetInt("_SeparationOn", _SeparationOn);
        Material.SetFloat("_RGBSeparationWidth", _RGBSeparationWidth);
        Material.SetFloat("_RGBSeparationThreshold", _RGBSeparationThreshold);
        Material.SetFloat("_NoiseParam5", _NoiseParam5);

        Material.SetInt("_MosicOn", _MosicOn);
        Material.SetFloat("_MosicLevelX", _MosicLevelX);
        Material.SetFloat("_MosicLevelY", _MosicLevelY);
        Material.SetFloat("_MosicThreshold", _MosicThreshold);

        Material.SetInt("_WaveOn", _WaveOn);
        Material.SetFloat("_WaveSpeed", _WaveSpeed);
        Material.SetFloat("_LineWidth", _LineWidth);
        Material.SetFloat("_LineIntensity", _LineIntensity);

        Material.SetInt("_SimpleNoiseOn", _SimpleNoiseOn);
        Material.SetFloat("_SimpleNoiseLevel", _SimpleNoiseLevel);
        Material.SetFloat("_SimpleNoiseScale", _SimpleNoiseScale);
        Material.SetFloat("_NoiseParam7", _NoiseParam7);

        Material.SetInt("_PixelizeOn", _PixelizeOn);
        Material.SetFloat("_PixelNum", _PixelNum);
        Material.SetFloat("_PixelSize", _PixelSize);
        Material.SetFloat("_PixelWidth", _PixelWidth);
    }
    //reset時の初期値を設定
    private void Reset()
    {
        _UVScalingX = 1;
        _UVScalingY = 1;

        _TimeScale = 7.6f;
        _UVHorizontalSlipOn = 1;
        _SlippingPosOffset = 0;
        _SlippingFrequency = 10;
        _SlippingLevel = 0.05f;
        _SlippingWidth = 0.5f;
        _NoiseParam1 = 50;
        _NoiseIntensity = 1;

        _VerticalSlipping = 0;

        _UVNoiseOn = 1;
        _NoiseFrequency = 60;
        _NoiseDetail = 1;
        _NoiseSpeed = 1;
        _NoiseThreshold = 0.25f;
        _NoiseWidth = 0.1f;

        _StretchOn = 1;
        _StretchIntensity = 2;
        _StretchLevel = 8;
        _StretchThreshold = 0.246f;
        _NoiseParam4 = 600;

        _SeparationOn = 1;
        _RGBSeparationWidth = 0.15f;
        _RGBSeparationThreshold = 0.295f;
        _NoiseParam5 = 5;

        _MosicOn = 1;
        _MosicLevelX = 256;
        _MosicLevelY = 256;
        _MosicThreshold = 0.07f;

        _WaveOn = 1;
        _WaveSpeed = 1;
        _LineWidth = 1;
        _LineIntensity = 0.463f;

        _SimpleNoiseOn = 1;
        _SimpleNoiseLevel = 0.5f;
        _SimpleNoiseScale = 50000;
        _NoiseParam7 = 50;

        _PixelizeOn = 1;
        _PixelNum = 256;
        _PixelSize = 0.8f;
        _PixelWidth = 0.8f;
        Debug.Log("Variables have been reset(Noise Effect).");
    }
    #endregion

}