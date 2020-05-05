# Blinn-Phong shading

Let:

- $\mathbf{q_i}$ be the position of the $i$th light
- $\mathbf{p}$ be the point of contact of the surface
- $\mathbf{\hat{n}}$ be the normal vector to the surface at the point $\mathbf{p}$
- $\mathbf{o}$ be the position of the camera

$$
I_p = C_{\mathrm{diff}} k_a I_a + \sum_i  C_{\mathrm{diff}} k_d I_i [\mathbf{\hat{n}} \cdot \mathbf{\hat{l}_i}]^+ + \sum_i C_{\mathrm{spec}} k_s I_i ([\mathbf{\hat{n}} \cdot \mathbf{\hat{h}_i}]^+)^\alpha
$$

where

- $C_{\mathrm{diff}}$ is the diffuse color of the object
- $C_{\mathrm{spec}}$ is the color of the light
- $0 \le k_a, k_s, k_d \le 1$ are coefficients for the proportion to which the object material takes each of the components
- $I_i$ is the intensity of the $i$th light at the point of contact, equal to $1/(4\pi |\mathbf{q_i} -\mathbf{p}|^2)$.
- $\mathbf{v} = \mathbf{o} - \mathbf{p}$
- $\mathbf{\hat{l}_i} = \text{normalize}(\mathbf{q_i} - \mathbf{p})$
- $\mathbf{\hat{h}_i} = \text{normalize}(\mathbf{\hat{l}_i} + \mathbf{v})$
