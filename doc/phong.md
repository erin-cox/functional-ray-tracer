# \zxc

## Blinn-Phong shading

For each material define:

- $k_a$: the ratio of reflection of the ambient term present throughout the scene
- $k_d$: the ratio of reflection of the diffuse term of incoming light (Lambertian reflectance)
- $k_s$: the ratio of reflection of the specular term of incoming light
- $\alpha$: a _shininess_ constant larger for surfaces that are smoother and more mirror-like

Further define:

- $C_\mathrm{diff}$: the diffuse color of the object
- $C_{\mathrm{spec},i}$: the color of the light
- $P$: the point on the surface
- $\text{lights}$: the set of all light sources in the scene
- $I_i$: the color of the $i$th light evaluated at $P$
- $\mathbf{\hat{l}_i}$: the unit vector from the $P$ towards the $i$th light source
- $\mathbf{\hat{n}}$: the unit normal to the surface at $P$
- $\mathbf{\hat{h}_i}$: the halfway vector between $\mathbf{\hat{l}_i}$ and the unit vector $\mathbf{\hat{v}}$ from $P$ towards the camera.

<img alt="Blinn-Phong vectors" src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Blinn_Vectors.svg/800px-Blinn_Vectors.svg.png" width="300">

Then the contribution of the color $I_P$ at $P$ is given by

$$
I_P = \underbrace{C_{\mathrm{diff}} k_a I_a}_\text{ambient term} + \sum_{i \in \text{lights}} \left(  \underbrace{C_{\mathrm{diff}} k_d I_i [\mathbf{\hat{n}} \cdot \mathbf{\hat{l}_i}]^+}_\text{diffuse term} + \underbrace{C_{\mathrm{spec},i} k_s I_i ([\mathbf{\hat{n}} \cdot \mathbf{\hat{h}_i}]^+)^\alpha}_\text{specular term} \right) \text{.}
$$

where $[x]^+ = \max(0, x)$.

-----

If we have as starting arguments:

- $\mathbf{q_i}$ as the position vector of the $i$th light
- $\mathbf{p}$ as the position vector of the point on the surface
- $\mathbf{\hat{n}}$ as above
- $\mathbf{o}$ as the position vector of the camera

We can calculate $\mathbf{\hat{l}_i}$ and $\mathbf{\hat{h}_i}$ as follows:

$$
\mathbf{\hat{l}_i} = \text{normalize}(\mathbf{q_i} - \mathbf{p})
$$

$$
\mathbf{\hat{h}_i} = \text{normalize}(\mathbf{\hat{l}_i} + \mathbf{o} - \mathbf{p})
$$

## The main trace function

Consider the following setup. We know $\mathbf{i}$, $\mathbf{n}$, $\eta_1$ and $\eta_2$.

![Setup](https://i.imgur.com/ghz8Ceu.png)

We can write the following formulae for $\mathbf{r}$ and $\mathbf{t}$ in terms of $\mathbf{i}$, $\mathbf{n}$, $\eta_1$ and $\eta_2$ only:

$$
\mathbf{r} = \mathbf{i} + 2\cos (\theta_i) \mathbf{n}
$$

$$
\mathbf{t} = \begin{cases}
\displaystyle\frac{\eta_1}{\eta_2}\mathbf{i} + \left( \frac{\eta_1}{\eta_2} \cos(\theta_i) - \sqrt{1 - \sin^2 (\theta_t)} \right) \mathbf{n} & \lnot \text{TIR} \\[1.0em]
\text{undefined} & \text{TIR}
\end{cases}
$$

where

$$
\cos(\theta_i) = -\mathbf{i} \cdot \mathbf{n}
$$

$$
\sin^2(\theta_t) = \left(\frac{\eta_1}{\eta_2}\right)^2 (1 - \cos^2(\theta_i))
$$

$$
\text{TIR} = \left\{ \sin(\theta_i) > \displaystyle\frac{\eta_2}{\eta_1} \right\} = \left\{ \sin(\theta_t) > 1\right\}
$$

Let:

- $0 \le \rho \le 1$ be the reflectivity of the medium.
- $R$ be the reflectance

Then the resultant color $\text{trace}(\mathbf{i})$ is given by

$$
\text{trace}(\mathbf{i}) = (1 - \rho) I_P + \rho R \cdot \text{trace}(\mathbf{r}) + \rho (1-R) \cdot \text{trace}(\mathbf{t}) \text{.}
$$

We have two formulae for the reflectance $R$. We can either average the *Fresnel equations*:

$$
R = \begin{cases} \frac{1}{2} (R_\perp + R_\parallel) & \lnot \text{TIR} \\
1 & \text{TIR}
\end{cases}
$$

$$
R_\perp = \left( \frac{\eta_1 \cos \theta_i - \eta_2 \cos \theta_t}{\eta_1 \cos \theta_i + \eta_2 \cos \theta_t} \right)^2
$$

$$
R_\parallel = \left( \frac{\eta_2 \cos \theta_i - \eta_1 \cos \theta_t}{\eta_2 \cos \theta_i + \eta_1 \cos \theta_t} \right)^2
$$

$$
\cos (\theta_t) = \sqrt{1 - \sin^2 (\theta_t)}
$$

Or we can use _Schlick's approximation_:

$$
R' = \begin{cases}
R_0 + (1-R_0)(1 - \cos \theta_i)^5 & \eta_1 \le \eta_2 \\
R_0 + (1-R_0)(1 - \cos \theta_t)^5 & \eta_1 > \eta_2 \land \lnot \text{TIR} \\
1 & \eta_1 > \eta_2 \land \text{TIR}
\end{cases}
$$

where

$$
R_0 = \left(\frac{\eta_1 - \eta_2}{\eta_1 + \eta_2}\right)^2
$$

[asdf](https://diglib.eg.org/bitstream/handle/10.2312/mam20191305/007-011.pdf)