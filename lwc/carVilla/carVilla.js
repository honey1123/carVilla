import { LightningElement, track } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import carVillaAssets from '@salesforce/resourceUrl/carVillaAssets';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CarVilla extends LightningElement {
    @track isLoaded = false;
    iframeUrl = 'https://carvilla.netlify.app/'; 
   
}