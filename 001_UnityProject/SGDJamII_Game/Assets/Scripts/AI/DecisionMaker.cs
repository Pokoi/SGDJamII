/*
 * File: DecisionMaker.cs
 * File Created: Tuesday, 22nd September 2020 2:10:22 pm
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
    public class DecisionMaker : MonoBehaviour
    {
        IntelligentAgent agent;
        ChangeHiddingPlace  changeHiddingPlaceAction;
        ChangeRoom          changeRoomAction;
        Wait                waitAction;

        private void Start()
        {
            agent = GetComponent<IntelligentAgent>();            
        }

        public Vector3 MakeADecision()
        {
            return Vector3.zero;
        }

        /**
        @brief Choose the best destiny room and gets its destination coordinates
        @return The destination coordinates of the desired room
        */
        public Vector3 ChooseDestinyRoom()
        {
            var rooms = RoomManager.singletonInstance.GetRooms();
            Room origin = agent.GetCurrentRoom();
            
            float bestHeuristic = float.MaxValue;
            Vector3 destiny = Vector3.zero;

            foreach (Room r in rooms)
            {
                if(r != origin)
                {
                    changeRoomAction.Reset(origin, r);
                    float h = changeRoomAction.CalculateHeuristic();
                    
                    if(h < bestHeuristic)
                    {
                        bestHeuristic = h;
                        destiny = changeRoomAction.GetDestination();
                    }
                }
            }

            return destiny;

        }

        /**
        @brief Choose the best destiny hidding place and gets its destination coordinates
        @return The destination coordinates of the desired hidding place
        */
        public Vector3 ChooseDestinyHiddingPlace()
        {
            var hiddingPlaces = agent.GetCurrentRoom().GetHiddingPlaces();
            HiddingPlace origin = agent.GetCurrentHiddingPlace();

            float bestHeuristic = float.MaxValue;
            Vector3 destiny = Vector3.zero;

            foreach (HiddingPlace hp in hiddingPlaces)
            {
                if(hp != origin && hp.GetMaxOccupation() > hp.GetCurrentOccupation())
                {
                    changeHiddingPlaceAction.Reset(origin, hp);
                    float h = changeHiddingPlaceAction.CalculateHeuristic();

                    if(h < bestHeuristic)
                    {
                        bestHeuristic = h;
                        destiny = changeHiddingPlaceAction.GetDestination();
                    }
                }
            }

            return destiny;

        }
    }
}
