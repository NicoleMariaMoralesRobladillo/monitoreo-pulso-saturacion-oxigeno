import { Routes } from '@angular/router';

export const routes: Routes = [
    {
        path: 'login',
        loadComponent: () => import('./login/login.component')
            .then(mod => mod.LoginComponent)
    },
    {
        path: 'arduinitos-portal',
        loadComponent: () => import('./portal/portal.component')
            .then(mod => mod.PortalComponent)    
    },
    {
        path: '',
        pathMatch: 'full',
        redirectTo: 'login'
    }
];
