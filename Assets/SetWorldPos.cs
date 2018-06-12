using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetWorldPos : MonoBehaviour {


	public Material mat;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		mat.SetVector("_WorldPos", transform.position);
	}


	void OnDrawGizmos()
	{
		mat.SetVector("_Position", transform.position);
	}
}
