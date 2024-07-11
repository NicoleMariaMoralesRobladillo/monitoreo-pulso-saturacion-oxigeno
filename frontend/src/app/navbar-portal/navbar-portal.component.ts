import { Component } from '@angular/core';
import { RouterModule, RouterOutlet } from '@angular/router';
import { AvatarModule } from 'primeng/avatar';
import { AvatarGroupModule } from 'primeng/avatargroup';
import { SidebarModule } from 'primeng/sidebar';

@Component({
  selector: 'app-navbar-portal',
  standalone: true,
  imports: [RouterOutlet, RouterModule,AvatarModule,AvatarGroupModule,SidebarModule],
  templateUrl: './navbar-portal.component.html',
  styleUrl: './navbar-portal.component.scss'
})
export class NavbarPortalComponent {
  public sidebarVisible = false;
  public changeSideMenu(): void {
    this.sidebarVisible = !this.sidebarVisible;
  }
}
