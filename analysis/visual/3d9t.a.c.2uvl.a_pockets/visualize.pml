load unbound_2uvl_a.pdb
load peptide_3d9t_c.pdb
color white, unbound_2uvl_a
color red, peptide_3d9t_c
show_as cartoon, all
orient
show sticks, peptide_3d9t_c
create unbound_2uvl_a.surface, unbound_2uvl_a; color white, unbound_2uvl_a.surface; set transparency, 0.6, unbound_2uvl_a.surface; show_as surface, unbound_2uvl_a.surface; disable unbound_2uvl_a.surface
load unbound_2uvl_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_2uvl_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_3d9t_c
