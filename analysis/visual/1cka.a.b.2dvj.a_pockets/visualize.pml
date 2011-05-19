load unbound_2dvj_a.pdb
load peptide_1cka_b.pdb
color white, unbound_2dvj_a
color red, peptide_1cka_b
show_as cartoon, all
orient
show sticks, peptide_1cka_b
create unbound_2dvj_a.surface, unbound_2dvj_a; color white, unbound_2dvj_a.surface; set transparency, 0.6, unbound_2dvj_a.surface; show_as surface, unbound_2dvj_a.surface; disable unbound_2dvj_a.surface
load unbound_2dvj_a_out/pockets/pocket*vert.pqr, pocket*vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1cka_b
