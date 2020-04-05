using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[SelectionBase]
public class PlayerMovement : MonoBehaviour
{
    public float speed = 6.0f;
    public float jumpSpeed = 8.0f;
    public float gravity = -9.8f;
    public float jumpHeight = 3f;

    public float groundDistance = .4f;
    public bool isMainController = false;
    public bool isChase = false;

    private Vector3 velocity;
    private CharacterController controller;
    private bool isGrounded;

    // Start is called before the first frame update
    void Start()
    {
        controller = GetComponent<CharacterController>();
    }

    // Update is called once per frame
    void Update()
    {
        Transform groundCheck = transform.Find("GroundCheck");
        LayerMask terrainMask = 1 << LayerMask.NameToLayer("Terrain");
        if (groundCheck == null)
        {
            return;
        }
        isGrounded = Physics.CheckSphere(groundCheck.position, groundDistance, terrainMask);

        if (isGrounded && velocity.y < 0)
        {
            velocity.y = -2f;
        }

        float horizontal = 0;
        float vertical = 0;

        if (isMainController)
        {
            horizontal = Input.GetAxisRaw("Horizontal");
            vertical = Input.GetAxisRaw("Vertical");
            var animator = GetComponentInChildren<Animator>();
            if (animator != null || true)
            {
                animator?.SetBool("Walking", Input.GetAxisRaw("Vertical") != 0);
            }
            Vector3 moveDirection = transform.right * horizontal + transform.forward * vertical;

            controller.Move(moveDirection * speed * Time.deltaTime);

            if (isMainController && Input.GetButtonDown("Jump") && isGrounded)
            {
                velocity.y = Mathf.Sqrt(jumpHeight * -2 * gravity);
            }
        }
        if (isChase)
        {
            LayerMask entity = 1 << LayerMask.NameToLayer("Entity");
            Collider[] hitColliders = Physics.OverlapSphere(transform.position, 100, entity);
            PlayerMovement target = GetClosestEnemy(hitColliders, 100);
            if (target != null)
            {

                Vector3 _direction = (target.transform.position - transform.position).normalized;
                Quaternion _lookRotation = Quaternion.LookRotation(_direction, Vector3.up);
                transform.rotation = _lookRotation;

                float xRotation = transform.eulerAngles.x > 180 ? transform.eulerAngles.x - 360 : transform.eulerAngles.x;
                float xRotationClamp = Mathf.Clamp(xRotation, -60f, 60f);
                transform.eulerAngles = new Vector3(xRotationClamp, transform.eulerAngles.y, transform.eulerAngles.z);

                Vector3 t = target.transform.position - transform.position;
                float dist = t.x * t.x + t.y * t.y + t.z * t.z;
                if (dist > 3 * 3)
                {
                    _direction.y = 0;
                    controller.Move(_direction * speed * Time.deltaTime);
                }
            }
        }

        velocity.y += gravity * Time.deltaTime;

        controller.Move(velocity * Time.deltaTime);
    }

    private PlayerMovement GetClosestEnemy(Collider[] enemies, float radius)
    {
        PlayerMovement cub = null;
        float minDist = radius * radius;
        Vector3 currentPos = transform.position;
        foreach (Collider c in enemies)
        {
            if (c.gameObject == gameObject)
                continue;
            PlayerMovement cube = c.GetComponent<PlayerMovement>();
            if (cube != null && cube.isMainController)
            {
                Vector3 t = c.transform.position - currentPos;
                float dist = t.x * t.x + t.y * t.y + t.z * t.z;
                if (dist < minDist)
                {
                    cub = cube;
                    minDist = dist;
                }
            }
        }
        return cub;
    }
}