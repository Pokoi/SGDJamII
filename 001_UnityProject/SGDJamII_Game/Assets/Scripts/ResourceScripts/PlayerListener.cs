using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace MessageSystem
{
    public class PlayerListener : MessageSystem.Listener
    {

        bool exposed = true;

        private void Awake()
        {
            MessageSystem.Dispatcher.singletonInstance.AddListener(this, "sneakEntry");
        }

        public override void Handle(string tag)
        {
            if (tag == "sneakEntry")
            {
                SetExposed(false);
            }
        }

        public bool GetExposed() => exposed;

        public void SetExposed(bool exposed) => this.exposed = exposed;

    }

}