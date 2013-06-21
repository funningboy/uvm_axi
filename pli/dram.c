#include <stdio.h>
#include <stdlib.h>
#include "vpi_user.h"
#include "vpi_user_cds.h"

//#define  MEM_SIZE 8*1024*1024 
#define  MEM_SIZE 40*1024*1024 
static unsigned int *p_base;

void mem_alloc() {
	p_base = (unsigned int*) malloc(sizeof(unsigned int)*MEM_SIZE>>2);

	if (p_base==NULL) {
		vpi_printf("[FAIL]: can not allocate memory\n");
		return;
	} else
		vpi_printf("[INFO]: allocate memory of %d byte successfully\n", MEM_SIZE);
}

void mem_free() {
	if (p_base==NULL) {
		vpi_printf("[FAIL]: memory pointer is wrong\n");
		return;
	} else
		free(p_base);	
}

void mem_read() {
  	vpiHandle systf_hdl;
  	vpiHandle arg_it;
  	vpiHandle arg_hdl;

  	s_vpi_value raddr;
  	s_vpi_value rdata;

  	systf_hdl = vpi_handle(vpiSysTfCall, NULL); 
  	
	if(!systf_hdl) {
    	vpi_printf("[WARN]: No task handle available \n");
    	return;
	}

	arg_it = vpi_iterate(vpiArgument, systf_hdl); 

  	if(!arg_it) {
    	vpi_printf("[FAIL]: No arguments for task mem_read\n");
    	return;
 	}

    arg_hdl = vpi_scan(arg_it);  

    raddr.format = vpiIntVal; 
    rdata.format = vpiIntVal; 
    
    vpi_get_value(arg_hdl, &raddr);
    //vpi_printf("[INFO]: raddr = %x\n ", raddr.value.integer);
	raddr.value.integer &= ~(0x03);
	raddr.value.integer >>= 2;
	

	if (raddr.value.integer>=MEM_SIZE) {
    	vpi_printf("[FAIL]: raddr = %x exceed range\n ", raddr.value.integer);
		exit(1);
	}
	
	rdata.value.integer = *(p_base+raddr.value.integer);
    
	arg_hdl = vpi_scan(arg_it);  
    vpi_put_value(arg_hdl, &rdata, NULL, vpiNoDelay);
}

void mem_write() {
  	vpiHandle systf_hdl;
  	vpiHandle arg_it;
  	vpiHandle arg_hdl;
  	
	s_vpi_value waddr;
	s_vpi_value we;
	s_vpi_value wdata;

	unsigned int temp;

  	systf_hdl = vpi_handle(vpiSysTfCall, NULL); 
	
	if(!systf_hdl) {
    	vpi_printf("[WARN]: No task handle available \n");
    	return;
	}
	
	arg_it = vpi_iterate(vpiArgument, systf_hdl); 

  	if(!arg_it) {
    	vpi_printf("[FAIL]: No arguments for task mem_write\n");
		return;
 	}

    arg_hdl = vpi_scan(arg_it);
    waddr.format = vpiIntVal; 
    vpi_get_value(arg_hdl, &waddr);
    //vpi_printf("[INFO]: waddr = %x\n ", waddr.value.integer);
	
	if (waddr.value.integer>=MEM_SIZE) {
    	vpi_printf("[FAIL]: waddr = %x exceed range\n ", waddr.value.integer);
		exit(1);
	}
    
	arg_hdl = vpi_scan(arg_it);  
    we.format = vpiIntVal; 
    vpi_get_value(arg_hdl, &we);
    //vpi_printf("[INFO]: we = %x\n ", we.value.integer);
	
	arg_hdl = vpi_scan(arg_it);  
    wdata.format = vpiIntVal; 
    vpi_get_value(arg_hdl, &wdata);
    //vpi_printf("[INFO]: wdata = %x\n ", wdata.value.integer);

	waddr.value.integer &= ~(0x03);
	waddr.value.integer >>= 2;

	temp = *(p_base+waddr.value.integer);

	if (we.value.integer&0x1) temp = (temp & ~(0x000000ff)) | (wdata.value.integer & 0x000000ff);
	if (we.value.integer&0x2) temp = (temp & ~(0x0000ff00)) | (wdata.value.integer & 0x0000ff00);
	if (we.value.integer&0x4) temp = (temp & ~(0x00ff0000)) | (wdata.value.integer & 0x00ff0000);
	if (we.value.integer&0x8) temp = (temp & ~(0xff000000)) | (wdata.value.integer & 0xff000000);

	*(p_base+waddr.value.integer) = temp;
}

void mem_init() {
  	vpiHandle systf_hdl;
  	vpiHandle arg_it;
  	vpiHandle arg_hdl;
  	
	s_vpi_value init_base;
	s_vpi_value init_name;
	
	int init_size;
	int temp;
	FILE *fp;
  	
	systf_hdl = vpi_handle(vpiSysTfCall, NULL); 
  	
	if(!systf_hdl) {
    	vpi_printf("[WARN]: No task handle available \n");
    	return;
	}

	arg_it = vpi_iterate(vpiArgument, systf_hdl); 

  	if(!arg_it) {
    	vpi_printf("[FAIL]: No arguments for task mem_init\n");
    	return;
 	}
    
	arg_hdl = vpi_scan(arg_it);  

    init_base.format = vpiIntVal; 
    init_name.format = vpiStringVal; 
    
    vpi_get_value(arg_hdl, &init_base);
    vpi_printf("[INFO]: init_base = %x\n ", init_base.value.integer);
	init_base.value.integer &= ~(0x03);
	init_base.value.integer >>= 2;
    
	arg_hdl = vpi_scan(arg_it);  
    vpi_get_value(arg_hdl, &init_name);
    vpi_printf("[INFO]: init_file = %s\n ", init_name.value.str);

	fp = fopen(init_name.value.str,"r");

	if (!fp) 
		printf("[FAIL]: can't open %s for init mem\n",init_name.value.str);

	fseek(fp,0,SEEK_END);
	init_size = ftell(fp);
    vpi_printf("[INFO]: init_size = %d\n ", init_size);

	// rewind to beginning
	fseek(fp,0,SEEK_SET);

	if (init_size>MEM_SIZE) {
    	vpi_printf("[FAIL]: init_size is greater than memory size\n ");
		exit(1);
	} 

	temp = fread(p_base+init_base.value.integer,1,init_size,fp);
	
	if (temp!=init_size)
		vpi_printf("[FAIL]: init file error\n");
	else
		vpi_printf("[INFO]: init file ok\n");

	fclose(fp);
}

void mem_dump() {
  	vpiHandle systf_hdl;
  	vpiHandle arg_it;
  	vpiHandle arg_hdl;

  	s_vpi_value dump_base;
  	s_vpi_value dump_size; 
  	s_vpi_value dump_name; 

	FILE *fp;

  	systf_hdl = vpi_handle(vpiSysTfCall, NULL); 
  	
	if(!systf_hdl) {
    	vpi_printf("[WARN]: No task handle available \n");
    	return;
	}

	arg_it = vpi_iterate(vpiArgument, systf_hdl); 

  	if(!arg_it) {
    	vpi_printf("[FAIL]: No arguments for task mem_dump\n");
    	return;
 	}

    arg_hdl = vpi_scan(arg_it);  

    dump_base.format = vpiIntVal; 
    dump_size.format = vpiIntVal; 
    dump_name.format = vpiStringVal; 
    
    vpi_get_value(arg_hdl, &dump_base);
    //vpi_printf("[INFO]: dump_base = %x\n ", dump_base.value.integer);
	dump_base.value.integer &= ~(0x03);
	dump_base.value.integer >>= 2;

    arg_hdl = vpi_scan(arg_it);  
    vpi_get_value(arg_hdl, &dump_size);
    //vpi_printf("[INFO]: dump_size = %x\n ", dump_size.value.integer);
	
	if (dump_base.value.integer>=MEM_SIZE) {
    	vpi_printf("[FAIL]: dump_base = %x exceed range\n ", dump_base.value.integer);
		exit(1);
	}
	
	if ((dump_base.value.integer+dump_size.value.integer)>=MEM_SIZE) {
    	vpi_printf("[FAIL]: dump_base+dump_size exceed range\n ");
		exit(1);
	}

    arg_hdl = vpi_scan(arg_it);  
    vpi_get_value(arg_hdl, &dump_name);
    
	vpi_printf("[INFO]: dump_file = %s\n ", dump_name.value.str);

	fp = fopen(dump_name.value.str,"wb");

	if (!fp) 
		printf("[FAIL]: can't open %s for dump mem\n",dump_name.value.str);
	
	fwrite(p_base+dump_base.value.integer,1,dump_size.value.integer,fp);

	fclose(fp);
}

// -----------------------------------------------------------------------------------------------------------------------------
void register_user_tasks() {
	s_vpi_systf_data task_data_s;
	
	p_vpi_systf_data task_data_p = &task_data_s;

	//------------------------------------------
	task_data_p->type = vpiSysTask;
	task_data_p->tfname = "$mem_alloc";
	task_data_p->calltf = (int(*)()) mem_alloc;
	task_data_p->compiletf = NULL;
	
	vpi_register_systf(task_data_p);
	//------------------------------------------
	task_data_p->type = vpiSysTask;
	task_data_p->tfname = "$mem_free";
	task_data_p->calltf = (int(*)()) mem_free;
	task_data_p->compiletf = NULL;
	
	vpi_register_systf(task_data_p);
	//------------------------------------------
	task_data_p->type = vpiSysTask;
	task_data_p->tfname = "$mem_read";
	task_data_p->calltf = (int(*)()) mem_read;
	task_data_p->compiletf = NULL;
	
	vpi_register_systf(task_data_p);
	//------------------------------------------
	task_data_p->type = vpiSysTask;
	task_data_p->tfname = "$mem_write";
	task_data_p->calltf = (int(*)()) mem_write;
	task_data_p->compiletf = NULL;
	
	vpi_register_systf(task_data_p);
	//------------------------------------------
	task_data_p->type = vpiSysTask;
	task_data_p->tfname = "$mem_dump";
	task_data_p->calltf = (int(*)()) mem_dump;
	task_data_p->compiletf = NULL;
	
	vpi_register_systf(task_data_p);
	//------------------------------------------
	task_data_p->type = vpiSysTask;
	task_data_p->tfname = "$mem_init";
	task_data_p->calltf = (int(*)()) mem_init;
	task_data_p->compiletf = NULL;
	
	vpi_register_systf(task_data_p);
	//------------------------------------------
} 

