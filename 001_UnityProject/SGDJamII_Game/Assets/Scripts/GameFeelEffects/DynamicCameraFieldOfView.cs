/*
 * File: DynamicCameraFieldOfView.cs
 * File Created: Friday, 25th September 2020 10:17:13 am
 * ––––––––––––––––––––––––
 * Author: Jesus Fermin, 'Pokoi', Villar  (hello@pokoidev.com)
 * ––––––––––––––––––––––––
 * MIT License
 * 
 * Copyright (c) 2020 Pokoidev
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */


using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using UnityEngine;

public class DynamicCameraFieldOfView : GameFeelEffect
{
    [SerializeField] private CinemachineFreeLook camera;
    [SerializeField] float modifier = 5.0f;
    Rigidbody playerRigidbody;
    float initialFieldOfView;
    float lastFieldOfView;

    private void Start()
    {
        Init();
    }


    public override void Init()
    {
        initialFieldOfView = camera.m_Lens.FieldOfView;
        playerRigidbody = transform.GetComponent<Rigidbody>();

        camera.m_CommonLens = true;

        MessageSystem.Dispatcher.singletonInstance.AddListener(this, "dynamicCameraFieldOfView");
    }

    public override void Apply()
    {
        float newFieldOfView = initialFieldOfView + (playerRigidbody.velocity.magnitude * modifier);
        float f = Mathf.Lerp(newFieldOfView, initialFieldOfView, Time.deltaTime);
        camera.m_Lens.FieldOfView = f;

        lastFieldOfView = f;

    }

    public override void Handle(string tag)
    {
        Apply();
    }
}
