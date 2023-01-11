Shader "Custom/Particle"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _myRange ("Range", Range(0, 2)) = 0.5
        _myBrightness ("Brightness", Range(0, 1)) = 0.5
        _myScale ("Scale", Range(0.1, 5)) = 1
        _myCube ("SampleCube", CUBE) = "" {}
        _myFloat ("Example Float", Float) = 0.5
        _myVector ("Example Vector", Vector) = (0.5, 1, 1, 1)
        _myBump ("Bump Texture", 2D) = "bump" {}
        _rimCol("Rim Color", Color) = (1, 1, 1, 1)
        _rimPower("Rim Power", Range(0.1, 5)) = 3
        //_Glossiness ("Smoothness", Range(0,1)) = 0.5
        //_Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        

        

        //half _Glossiness;
        //half _Metallic;
        fixed4 _Color;
        sampler2D _MainTex;
        half _myRange;
        half _myBrightness;
        half _myScale;
        samplerCUBE _myCube;
        float _myFloat;
        float4 _myVector;
        sampler2D _myBump;
        half _rimPower;
        fixed4 _rimCol;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_myBump;
            float3 worldRefl; INTERNAL_DATA
            float3 viewDir;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex * _myScale) * _Color;
            half rim = dot(normalize(IN.viewDir), o.Normal);
            o.Albedo = c.rgb;
            //o.Alpha = c.a;
            o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump * _myScale));
            o.Normal *= float3(_myRange, _myRange, _myBrightness);
            //o.Emission = texCUBE(_myCube, IN.worldRefl).rgb;
            o.Emission = texCUBE(_myCube, WorldReflectionVector (IN, o.Normal)).rgb * pow((1-rim), _rimPower) * _rimCol;
            // Metallic and smoothness come from slider variables
            //o.Metallic = _Metallic;
            //o.Smoothness = _Glossiness;
            //o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
