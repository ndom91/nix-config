# Using agenix: https://github.com/ryantm/agenix#tutorial
let
  ndo = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRAbAylECwZpvAOEq69apq5J1OAAF3kaTebhuqOps2O7WoJCCylqzu7rrPAun2tE3tsjeqwEdFMjSXYxBQowp5b0HiAT6w1Mtwy6PgjnQW5/VOsTYpg1dl3hw1ZiRYa1yUT+xfVba4+POEKXizpMjL8xlkW/ugnj2WL8O85QplqIGRRIsSAa4jBsZ3d1j88iSv0ZFpTXdTuf9EISNFBrIXq7f+JyhtGZqaj4m67CNoxPiadfyX7XrgVKra8/SaYa00RebI4V+tp6NDhJL6LZN8rX2O1a7O6NCUhZ1avYw4aY00kMyGqx2bR55ml7jN9k/edaKqHJInff8cPefa45ub";
in
{
  "sshHosts.age".publicKeys = [ ndo ];
  "wutangKey.age".publicKeys = [ ndo ];
  "pvpnKey.age".publicKeys = [ ndo ];
  "cbaseKey.age".publicKeys = [ ndo ];
  "derpyKey.age".publicKeys = [ ndo ];
}
