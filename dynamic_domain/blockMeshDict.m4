/*--------------------------------*- C++ -*----------------------------------*\
| =========                 |                                                 |
| \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |
|  \\    /   O peration     | Version:  2.0.1                                 |
|   \\  /    A nd           | Web:      www.OpenFOAM.com                      |
|    \\/     M anipulation  |                                                 |
\*---------------------------------------------------------------------------*/
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      blockMeshDict;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
m4_divert(-1)
#----------------------------------
m4_changecom(//)m4_changequote([,])
m4_define(calc, [m4_esyscmd(perl -e 'printf ($1)')])
m4_define(pi, 3.14159265358979323844)
m4_define(rad, [calc($1*pi/180.0)])
#----------------------------------

#----------------------------------
# Unidades (convertToMeters)
m4_define(units, 1)

# Datos del disco del rotor
m4_define(r_rotor,      62.9 )             # radio del rotor
m4_define(x_rotor_pos,   3.5 )             # disco del rotor x+
m4_define(x_rotor_neg, -30.0 )             # disco del rotor x-
m4_define(r_disco,  [calc(1.5*r_rotor)])   # radio del disco del rotor  1.5 * radio del rotor

m4_define(r2, calc(r_rotor/10))            # radio interior

# definicion de los arcos
m4_define(rsin, [calc(r_disco*sin(rad(45)))])
m4_define(rcos, [calc(r_disco*cos(rad(45)))])

# Bloques parte media
m4_define(x_block, 40)
m4_define(y_block, 40)
m4_define(z_block, 40)
m4_define(grading_block, 1 1 1)

m4_divert(0)
convertToMeters units;

vertices
(
    ( x_rotor_pos  r2  r2 )
    ( x_rotor_pos -r2  r2 )
    ( x_rotor_pos -r2 -r2 )
    ( x_rotor_pos  r2 -r2 )
 
    ( x_rotor_pos  rcos  rsin )
    ( x_rotor_pos -rcos  rsin )
    ( x_rotor_pos -rcos -rsin )
    ( x_rotor_pos  rcos -rsin )
 
    ( x_rotor_neg   r2 r2 )
    ( x_rotor_neg  -r2 r2 )
    ( x_rotor_neg -r2 -r2 )
    ( x_rotor_neg  r2 -r2 )
 
    ( x_rotor_neg  rcos  rsin )
    ( x_rotor_neg -rcos  rsin )
    ( x_rotor_neg -rcos -rsin )
    ( x_rotor_neg  rcos -rsin )
);

blocks
(
    hex (0  8  9 1 4 12 13 5) rotor (x_block y_block z_block) simpleGrading (grading_block)
    hex (1  9 10 2 5 13 14 6) rotor (x_block y_block z_block) simpleGrading (grading_block)
    hex (2 10 11 3 6 14 15 7) rotor (x_block y_block z_block) simpleGrading (grading_block)
    hex (3 11  8 0 7 15 12 4) rotor (x_block y_block z_block) simpleGrading (grading_block)
    hex (3 11 10 2 0  8  9 1) rotor (x_block y_block z_block) simpleGrading (grading_block)
);

edges
(
    arc 4 5 ( x_rotor_pos        0  r_disco )
    arc 5 6 ( x_rotor_pos -r_disco        0 )
    arc 6 7 ( x_rotor_pos        0 -r_disco )
    arc 7 4 ( x_rotor_pos  r_disco        0 )

    arc 12 13 ( x_rotor_neg           0  r_disco )
    arc 13 14 ( x_rotor_neg    -r_disco        0 )
    arc 14 15 ( x_rotor_neg           0 -r_disco )
    arc 15 12 ( x_rotor_neg     r_disco        0 )

);

boundary
(
    AMI2             // patch name
    {
       type patch;    // patch type for patch 1
       faces
       (
          (  0  1  2  3 )
          (  6 14 15  7 )
          (  7 15 12  4 )
          (  4 12 13  5 )
          (  5 13 14  6 )
          (  0  3  7  4 )
          (  0  4  5  1 )
          (  1  5  6  2 )
          (  2  6  7  3 )
          (  8  9 10 11 )
          (  8 12 13  9 )
          (  9 13 14 10 )
          ( 10 14 15 11 )
          ( 11 15 12  8 )
        );
     }
);

mergePatchPairs
(
);

// ************************************************************************* //
