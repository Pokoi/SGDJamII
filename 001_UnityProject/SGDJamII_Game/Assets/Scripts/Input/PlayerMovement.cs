using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField] private float startSpeed;
    private float currentSpeed;
    [Range(0f, 1f)] [SerializeField] private float buildUpSpeed;

    private float minInput;
    private Vector2 movementInput;
    private Vector2 newMovementInput;
    private Vector3 forward;
    private Vector3 right;

    [HideInInspector]
    public bool running;

    private Rigidbody rb;

    private PlayerInputHandler playerInput;

    public float rotationSpeed = 1.2f;

    void Awake()
    {
        forward = Camera.main.transform.forward;
        forward.y = 0;
        forward.Normalize();
        right = Quaternion.Euler(new Vector3(0, 90, 0)) * forward;

        rb = GetComponent<Rigidbody>();
        playerInput = GetComponent<PlayerInputHandler>();

        currentSpeed = startSpeed;

    }

    void FixedUpdate()
    {
        rb.velocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;

        newMovementInput = playerInput.movementInput;
        //if (newMovementInput.magnitude < minInput)
        //    newMovementInput = Vector2.zero;

        float realBuildUpSpeed = 1f - Mathf.Pow(1f - buildUpSpeed, Time.deltaTime * 60);
        movementInput = Vector2.Lerp(movementInput, newMovementInput, realBuildUpSpeed);

        // Movement ---------------------------------------------------
        //Vector3 hMovement;
        //Vector3 vMovement;


        // hMovement = transform.right * movementInput.x;
        //vMovement = transform.forward * movementInput.y;

        if (running)
            currentSpeed = startSpeed * 1.5f;



        // Vector3 finalMovement = Vector3.ClampMagnitude((hMovement + vMovement), 1.0f) * currentSpeed * Time.deltaTime;



        //// Rotation ---------------------------------------------------
        //if (newMovementInput.magnitude > minInput)
        //{
        //    //Vector3 heading = (hMovement + vMovement);
        //    //transform.forward = heading;

        //}
        Vector3 heading = (Vector3.Normalize(Camera.main.transform.forward) * movementInput.y +
            Vector3.Normalize(Camera.main.transform.right) * movementInput.x);

        heading.y = 0.0f;

        transform.forward = Vector3.Slerp(transform.forward, heading, rotationSpeed * Time.deltaTime);


        transform.position += heading
            * Time.deltaTime * currentSpeed;
        

        currentSpeed = startSpeed;
    }
}
