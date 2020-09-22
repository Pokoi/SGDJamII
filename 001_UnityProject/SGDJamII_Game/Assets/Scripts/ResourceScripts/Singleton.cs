using UnityEngine;

public class Singleton<T> : MonoBehaviour where T : MonoBehaviour
{
	private static T instance_ = null;
	public bool DontDestroyOnLoad = true;
	// Game Instance Singleton
	public static T Instance
	{
		get
		{
			if (instance_ == null)
			{
				instance_ = FindObjectOfType<T>();

				if(instance_ == null)
				{
					GameObject g = new GameObject("Instancia de " + typeof(T));
					instance_ = g.AddComponent<T>();
				}
			}
			return instance_;
		}
	}

	public void Awake()
	{
		if (instance_ != null)// && instance_ != this)
			DestroyImmediate(this);
		else if(DontDestroyOnLoad)
			DontDestroyOnLoad(gameObject);
	}
}
