diff --git a/pkgs/devcontainer/container.nix b/pkgs/devcontainer/container.nix
index d013a2b..b684269 100644
--- a/pkgs/devcontainer/container.nix
+++ b/pkgs/devcontainer/container.nix
@@ -18,13 +18,17 @@ let
 
   home = homeConfig.activationPackage;
 
+  closureInfo = pkgs.closureInfo {
+    rootPaths = [ home ];
+  };
+
   activationScript = pkgs.writeShellScript "activate-nix-env.sh" ''
-    # [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] || "${home}/activate"
-    echo HM command: ${home}/activate
-    # . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
-    # export COLORTERM=truecolor
-    # exec nu
-    ${pkgs.bash}/bin/bash
+    ${pkgs.nix}/bin/nix-store --init
+    ${pkgs.nix}/bin/nix-store --load-db < ${closureInfo}/registration
+    [ -e "$HOME/.nix-profile" ] || "${home}/activate"
+    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
+    export COLORTERM=truecolor
+    exec nu
   '';
 
   shadow = with pkgs;
@@ -60,6 +64,7 @@ in pkgs.dockerTools.streamLayeredImage {
     Env = [
       "USER=${userName}"
       "HOME=/home/${userName}"
+      "PATH=/home/${userName}/.nix-profile/bin:/bin"
       "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
       "NIX_PAGER=cat"
     ];
