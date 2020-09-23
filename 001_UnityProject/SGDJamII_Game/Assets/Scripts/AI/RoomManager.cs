/*
 * File: RoomManager.cs
 * File Created: Tuesday, 22nd September 2020 1:43:34 pm
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

namespace ArtificialIntelligence
{
    public class RoomManager : MonoBehaviour
    {
        [SerializeField] private List<ArtificialIntelligence.Room> rooms = new List<ArtificialIntelligence.Room>(); 
        [SerializeField] private List<List<float>> distanceMatrix;
        [SerializeField] private Transform goal;

        public static ArtificialIntelligence.RoomManager singletonInstance;
        

        private void Awake() 
        {
            if(singletonInstance == null)
            {
                singletonInstance = this;
            }
            else
            {
                Destroy(this);
            }    
        }



        /**
        @brief Genereate the nav mesh distances relevants in each room 
        */
        public void GenerateDistances()
        {
            
            // TODO calculate distance from each room door to goal
            // TODO calculate distance from each room hidding place to room door
            // TODO calculate distance between each room            
        }


        /**
        @brief Get the distance between two rooms 
        @param origin The origin room
        @param destiny The destiny room
        @return The distance
        */
        public float GetDistanceBetween(ArtificialIntelligence.Room origin, ArtificialIntelligence.Room destiny)
        {
            if(origin != destiny)
            {                
                int originIndex = 0;
                int destinyIndex = 0;

                int iterator = 0;

                // Search the index of each room
                foreach(ArtificialIntelligence.Room r in rooms)
                {
                    if(r == origin) originIndex = iterator;
                    else if (r == destiny) destinyIndex = iterator;
                    ++iterator;
                }

                return distanceMatrix[originIndex][destinyIndex];
            }

            return 0.0f;       

        }

        public List<ArtificialIntelligence.Room> GetRooms() => rooms;  
        public Transform GetGoal()=> goal;     

        public void AddRoom(ArtificialIntelligence.Room room) => rooms.Add(room);

    }

}

