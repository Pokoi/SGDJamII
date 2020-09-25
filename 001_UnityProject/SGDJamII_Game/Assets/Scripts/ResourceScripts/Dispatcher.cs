/*
 * File: Dispatcher.cs
 * File Created: Friday, 25th September 2020 10:42:13 am
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
using UnityEngine;


namespace MessageSystem
{    public class Dispatcher : MonoBehaviour
    {
        public static Dispatcher singletonInstance;
        Dictionary<string, List<Listener>> listeners;        

        private void Awake()
        {
            if (singletonInstance == null)
            {
                DestroyImmediate(this);
            }
            
            singletonInstance = this;
            listeners = new Dictionary<string, List<Listener>>();           
        }

        /**
        @brief Adds a listener to the dispatcher collection with the given tag
        @ param listener The listener to add 
        @ param tag The tag this listener is subscribed to
        */
        public void AddListener(Listener listener, string tag)
        {
            if (!listeners.ContainsKey(tag))
            {
                listeners.Add(tag, new List<Listener>());
            }

            listeners[tag].Add(listener);
        }

        /**
        @brief Removes a listener from the dispatcher collection with the given tag
        @ param listener The listener to remove 
        @ param tag The tag this listener is subscribed to
        */
        public void RemoveListener(Listener listener, string tag)
        {
            if (listeners.ContainsKey(tag))
            {
                listeners[tag].Remove(listener);                
            }
        }

        /**
        @brief Sends an alert to all the listeners subscribed to the given tag 
        @ param tag The tag this listener are subscribed to
        */
        public void Send(string tag)
        {
            if (listeners.ContainsKey(tag))
            {             
                foreach (Listener l in listeners[tag])
                {
                    l.Handle(tag);
                }
            }
        }

    }
}
