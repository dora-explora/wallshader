use anyhow::Result;
use log::warn;
use wgpu::{CurrentSurfaceTexture, LoadOp, Operations, RenderPassColorAttachment, RenderPassDescriptor, StoreOp, TextureViewDescriptor};

use crate::*;

impl State {
    pub fn render(&self) -> Result<()> {
        if self.surface.get_configuration() == None {
            return Ok(());
        }

        let surface_texture;
        loop {
            match self.surface.get_current_texture() {
                CurrentSurfaceTexture::Success(s) => { surface_texture = s; break; },
                CurrentSurfaceTexture::Suboptimal(s) => {
                    self.surface.configure(&self.device, &self.surface.get_configuration().unwrap());
                    surface_texture = s;
                    break;
                },
                CurrentSurfaceTexture::Timeout => warn!("Timeout while trying to configure surface"), // just tries again
                CurrentSurfaceTexture::Occluded => warn!("Surface occluded while trying to configure surface"), // also just tries again
                CurrentSurfaceTexture::Outdated => { self.surface.configure(&self.device, &self.surface.get_configuration().unwrap()); },
                CurrentSurfaceTexture::Lost => panic!("Surface lost while trying to configure surface"),
                CurrentSurfaceTexture::Validation => panic!("Validation error while trying to configure surface")
            }
        }

        let texture_view = surface_texture.texture.create_view(&TextureViewDescriptor::default());

        let mut encoder = self.device.create_command_encoder(&Default::default());
        {
            let mut render_pass = encoder.begin_render_pass(&RenderPassDescriptor {
                label: None,
                color_attachments: &[Some(RenderPassColorAttachment {
                    view: &texture_view,
                    resolve_target: None,
                    depth_slice: None,
                    ops: Operations {
                        load: LoadOp::Clear(wgpu::Color { r: 0.5, g: 0.7, b: 1., a: 1. }),
                        store: StoreOp::Store,
                    },
                })],
                depth_stencil_attachment: None,
                timestamp_writes: None,
                occlusion_query_set: None,
                multiview_mask: None,
            });

            render_pass.set_pipeline(&self.render_pipeline);
            render_pass.draw(0..3,0..1);
        }

        self.queue.submit(Some(encoder.finish()));
        surface_texture.present();

        return Ok(());
    }
}
