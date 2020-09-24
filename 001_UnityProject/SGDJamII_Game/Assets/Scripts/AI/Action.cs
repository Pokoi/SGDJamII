/*
 * File: Action.cs
 * File Created: Tuesday, 22nd September 2020 2:11:31 pm
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
    public class Action : MonoBehaviour
    {  
            
        protected ArtificialIntelligence.IntelligentAgent agent;
        public virtual float CalculateHeuristic()
        {
            return 0.0f;
        }

        public void SetAgent(ArtificialIntelligence.IntelligentAgent agent) => this.agent = agent;
    }

    public class ChangeRoom : ArtificialIntelligence.Action
    {
        [SerializeField] private ArtificialIntelligence.Room origin;
        [SerializeField] private ArtificialIntelligence.Room destiny; 

        [SerializeField] private struct Weights
        {
            public float distanceBetweenRooms;
            public float hiddingPlacesDestinyRoom;
            public float hiddingPlacesOriginRoom;
            public float originRoomDistanceToGoal;
            public float destinyRoomDistanceToGoal;
            public float distanceToSuspectionFromOrigin;
            public float distanceToSuspectionFromDestiny;

            public Weights(bool b)
            {
                distanceBetweenRooms = 0.14f;
                hiddingPlacesDestinyRoom = 0.14f;
                hiddingPlacesOriginRoom = 0.14f;
                originRoomDistanceToGoal = 0.14f;
                destinyRoomDistanceToGoal = 0.14f;
                distanceToSuspectionFromOrigin = 0.14f;
                distanceToSuspectionFromDestiny = 0.14f;
            }
        }

        Weights weights = new Weights(true); 

        /**
        @brief Reset the action with the given params
        @param origin The origin room
        @param destiny The destiny room
        */
        public void Reset(ArtificialIntelligence.Room origin, ArtificialIntelligence.Room destiny)
        {
            this.origin     = origin;
            this.destiny    = destiny;
        }

        /**
        @brief Calculate the heuristic value of the action
        @return The heuristic value
        */
        public override float CalculateHeuristic()
        {
            var suspicion = agent.GetSuspicionLocation();

            return  weights.distanceBetweenRooms * RoomManager.singletonInstance.GetDistanceBetween(origin, destiny) +
                    weights.hiddingPlacesOriginRoom * origin.GetHiddingPlacesCount() +
                    weights.hiddingPlacesDestinyRoom * destiny.GetHiddingPlacesCount() + 
                    weights.originRoomDistanceToGoal * origin.GetDistanceToGoal() + 
                    weights.destinyRoomDistanceToGoal * destiny.GetDistanceToGoal() + 
                    weights.distanceToSuspectionFromOrigin * RoomManager.singletonInstance.GetDistanceBetween(origin, suspicion) + 
                    weights.distanceToSuspectionFromDestiny * RoomManager.singletonInstance.GetDistanceBetween(destiny, suspicion);
        }

        /**
        @brief Gets the destination of the action
        @return The destination coordinates
        */
        public Vector3 GetDestination() => destiny.GetDoor().transform.position;
        
    }

    public class ChangeHiddingPlace : Action
    {
        [SerializeField] private ArtificialIntelligence.HiddingPlace origin;
        [SerializeField] private ArtificialIntelligence.HiddingPlace destiny;

        [SerializeField] private struct Weights
        {
            public float originOccupation;
            public float destinyOccupation;
            public float distanceToGoalFromOrigin;
            public float distanceToGoalFromDestiny;
            public float chanceToRevealPositionOrigin;
            public float chanceToRevealPositionDestiny;

            public Weights (bool b)
            {
                originOccupation = 0.15f;
                destinyOccupation = 0.15f;
                distanceToGoalFromOrigin = 0.15f;
                distanceToGoalFromDestiny = 0.15f;
                chanceToRevealPositionOrigin = 0.15f;
                chanceToRevealPositionDestiny = 0.15f;
            }
        } 

        Weights weights = new Weights(true); 

        /**
        @brief Reset the action with the given params
        @param origin The origin hidding place
        @param destiny The destiny hidding place
        */
        public void Reset(ArtificialIntelligence.HiddingPlace origin, ArtificialIntelligence.HiddingPlace destiny)
        {
            this.origin     = origin;
            this.destiny    = destiny;
        }
       
        /**
        @brief Calculate the heuristic value of the action
        @return The heuristic value
        */
        public override float CalculateHeuristic()
        {
            return  weights.originOccupation * origin.GetOccupationRate() +
                    weights.destinyOccupation * destiny.GetOccupationRate() +
                    weights.distanceToGoalFromOrigin * (origin.GetDistanceToExitRoom() + origin.GetOwnerRoom().GetDistanceToGoal()) +
                    weights.distanceToGoalFromDestiny * (destiny.GetDistanceToExitRoom() + destiny.GetOwnerRoom().GetDistanceToGoal()) +
                    weights.chanceToRevealPositionOrigin * origin.GetChanceToRevealPosition() + 
                    weights.chanceToRevealPositionDestiny * destiny.GetChanceToRevealPosition();
        }

        /**
        @brief Gets the destination of the action
        @return The destination coordinates
        */
        public Vector3 GetDestination() => destiny.transform.position;
    }

    public class ChooseHiddingPlace : ArtificialIntelligence.Action
    {
        [SerializeField] private ArtificialIntelligence.HiddingPlace destiny;

        [SerializeField] private struct Weights
        {     
            public float destinyOccupation; 
            public float chanceToRevealPositionDestiny;
        } 

        Weights weights;

        /**
        @brief Reset the action with the given params
        @param destiny The destiny hidding place
        */
        public void Reset(ArtificialIntelligence.HiddingPlace destiny)
        {
            this.destiny    = destiny;
        }

        /**
        @brief Calculate the heuristic value of the action
        @return The heuristic value
        */
        public override float CalculateHeuristic()
        {
            return  weights.destinyOccupation * destiny.GetOccupationRate() +              
                    weights.chanceToRevealPositionDestiny * destiny.GetChanceToRevealPosition();
        }

        /**
        @brief Gets the destination of the action
        @return The destination coordinates
        */
        public Vector3 GetDestination() => destiny.transform.position;
    }

    public class Wait : ArtificialIntelligence.Action
    {
        /**
        @brief Gets the destination of the action
        @return The destination coordinates
        */
        public Vector3 GetDestination() => agent.transform.position;
    }

    public class Goal : ArtificialIntelligence.Action
    {
        /**
        @brief Gets the destination of the action
        @return The destination coordinates
        */
        public Vector3 GetDestination() => RoomManager.singletonInstance.GetGoal().position;
    }

}