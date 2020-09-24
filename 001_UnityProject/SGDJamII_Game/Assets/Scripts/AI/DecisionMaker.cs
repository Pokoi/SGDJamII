﻿/*
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

        public enum ActionTypes { CHANGE_HIDDING_PLACE, CHOOSE_HIDDING_PLACE, CHANGE_ROOM, WAIT, GOAL};

        private ActionTypes currentAction;

        ArtificialIntelligence.IntelligentAgent     agent;
        ArtificialIntelligence.ChangeHiddingPlace  changeHiddingPlaceAction = new ArtificialIntelligence.ChangeHiddingPlace();
        ArtificialIntelligence.ChooseHiddingPlace  chooseHiddingPlaceAction = new ArtificialIntelligence.ChooseHiddingPlace();
        ArtificialIntelligence.ChangeRoom          changeRoomAction = new ArtificialIntelligence.ChangeRoom();
        ArtificialIntelligence.Wait                waitAction = new ArtificialIntelligence.Wait();
        ArtificialIntelligence.Goal                goalAction = new ArtificialIntelligence.Goal();

        public ActionTypes GetCurrentAction() => currentAction;

        private void Start()
        {
            agent = GetComponent<IntelligentAgent>(); 

            changeHiddingPlaceAction.SetAgent(agent);
            chooseHiddingPlaceAction.SetAgent(agent);
            changeRoomAction.SetAgent(agent);
            waitAction.SetAgent(agent);
            goalAction.SetAgent(agent);           
        }

        public Vector3 MakeADecision()
        {
            float changeHiddingPlaceHeuristic = 0.0f;
            float chooseHiddingPlaceHeuristic = 0.0f;
            float changeRoomHeuristic = 0.0f;
            float waitinghHeuristic = 0.0f;       

            // In case the AI is in the same room of the goal, the AI runs to the goal point
            if(agent.GetCurrentRoom() != null && agent.GetCurrentRoom().GetIsGoal())
            {
                return Goal();
            }

            var suspicion = agent.GetSuspicionLocation();

            if (agent.GetCurrentHiddingPlace() == null)
            {                            
                changeRoomHeuristic = agent.GetPsychology().changeRoomWeight * agent.GetCurrentRoom().GetDistanceToGoal();
                chooseHiddingPlaceHeuristic = agent.GetPsychology().searchingHiddingPlaceWeight * RoomManager.singletonInstance.GetDistanceBetween(agent.GetCurrentRoom(), suspicion);           
               
                return changeRoomHeuristic < chooseHiddingPlaceHeuristic ? ChooseDestinyRoom() : ChooseDestinyHiddingPlace();              
            }          
            else
            {
                waitinghHeuristic = agent.GetPsychology().waitingWeight * RoomManager.singletonInstance.GetDistanceBetween(agent.GetCurrentRoom(), suspicion);
                changeRoomHeuristic = agent.GetPsychology().changeRoomWeight * agent.GetCurrentRoom().GetDistanceToGoal();
                changeHiddingPlaceHeuristic = agent.GetPsychology().changeHiddingPlaceWeight * RoomManager.singletonInstance.GetDistanceBetween(agent.GetCurrentRoom(), suspicion);

                if(waitinghHeuristic < changeRoomHeuristic)
                {
                    if(waitinghHeuristic < changeHiddingPlaceHeuristic)
                    {
                        return Wait();
                    }
                    else
                    {
                        return  ChooseNewDestinyHiddingPlace();
                    }
                }
                else if(changeRoomHeuristic < changeHiddingPlaceHeuristic)
                {
                    return ChooseDestinyRoom();
                }
                else
                {
                    return ChooseNewDestinyHiddingPlace();
                }
            }

            return Vector3.zero;
        }

        /**
        @brief Choose the best destiny room and gets its destination coordinates
        @return The destination coordinates of the desired room
        */
        public Vector3 ChooseDestinyRoom()
        {
            var rooms = RoomManager.singletonInstance.GetRooms();
            ArtificialIntelligence.Room origin = agent.GetCurrentRoom();
            
            float bestHeuristic = float.MaxValue;
            Vector3 destiny = Vector3.zero;

            foreach (ArtificialIntelligence.Room r in rooms)
            {
                if(r != origin)
                {
                    changeRoomAction.Reset(origin, r);                  
                    ChangeDestinationWhenHeuristicImprovement
                                                            (
                                                                changeRoomAction.CalculateHeuristic(),
                                                                ref bestHeuristic,
                                                                changeRoomAction.GetDestination(),
                                                                ref destiny
                                                            );      
                }
            }

            currentAction = ActionTypes.CHANGE_ROOM;
            
            Debug.Log(currentAction);
            return destiny;

        }

        /**
        @brief Choose the best destiny hidding place in a room, not being hidden already, and gets its destinarion coordinates
        @return The destination coordinates of the desired hidding place
        */
        public Vector3 ChooseDestinyHiddingPlace()
        {
            var hiddingPlaces = agent.GetCurrentRoom().GetHiddingPlaces();
            
            float bestHeuristic = float.MaxValue;
            Vector3 destiny = Vector3.zero;

            foreach(ArtificialIntelligence.HiddingPlace hp in hiddingPlaces)
            {
                if(hp.GetMaxOccupation() > hp.GetCurrentOccupation())
                {
                    chooseHiddingPlaceAction.Reset(hp);
                    ChangeDestinationWhenHeuristicImprovement
                                                            (
                                                                chooseHiddingPlaceAction.CalculateHeuristic(),
                                                                ref bestHeuristic,
                                                                chooseHiddingPlaceAction.GetDestination(),
                                                                ref destiny
                                                            );           
                }

            }

            currentAction = ActionTypes.CHOOSE_HIDDING_PLACE;
            Debug.Log(currentAction);
            return destiny;
        }

        /**
        @brief Choose the best destiny hidding place and gets its destination coordinates
        @return The destination coordinates of the desired hidding place
        */
        public Vector3 ChooseNewDestinyHiddingPlace()
        {
            var hiddingPlaces = agent.GetCurrentRoom().GetHiddingPlaces();
            ArtificialIntelligence.HiddingPlace origin = agent.GetCurrentHiddingPlace();

            float bestHeuristic = float.MaxValue;
            Vector3 destiny = Vector3.zero;

            foreach (ArtificialIntelligence.HiddingPlace hp in hiddingPlaces)
            {
                if(hp != origin && hp.GetMaxOccupation() > hp.GetCurrentOccupation())
                {
                    changeHiddingPlaceAction.Reset(origin, hp);                  
                    ChangeDestinationWhenHeuristicImprovement
                                                            (
                                                                changeHiddingPlaceAction.CalculateHeuristic(),
                                                                ref bestHeuristic,
                                                                changeHiddingPlaceAction.GetDestination(),
                                                                ref destiny
                                                            );                    
                }
            }

            currentAction = ActionTypes.CHANGE_HIDDING_PLACE;
            agent.Unhide();
            Debug.Log(currentAction);
            return destiny;
        }

        /**
        @brief Gets the waiting position
        @return The waiting position
        */
        public Vector3 Wait()
        {
            currentAction = ActionTypes.WAIT;
            Debug.Log(currentAction);
            return waitAction.GetDestination();
        }

        /**
        @brief Gets the coordinates of the goal destination
        @return The goal destination coordinates
        */
        public Vector3 Goal()
        {
            currentAction = ActionTypes.GOAL;
            Debug.Log(currentAction);
            return goalAction.GetDestination();
        }

        /**
        @brief Change the destination if the new heuristic is better than the old one
        @param new_heuristic The new heuristic obtained
        @param best The best heuristic at the moment. This value will change if the new one is better
        @param new_destiny The new destiny if the heuristic is better
        @param destiny The destiny at the moment. This value will change if the new one is better
        */
        private void  ChangeDestinationWhenHeuristicImprovement(float new_heuristic, ref float best, Vector3 new_destiny, ref Vector3 destiny)
        {
            if(new_heuristic < best)
            {
                best = new_heuristic;
                destiny = new_destiny;
            }
        }






    }
}
